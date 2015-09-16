require 'open-uri'
require 'zip'

class ProtegeImporter

  # This is the STAGING protege URL, will need to switch this to Production
  ZIP_URL = "http://52.4.82.207:8080/webprotege/download?ontology=0aa09276-58a6-4350-a0bb-60eb2ab4be00"

  def initialize(resource = ZIP_URL)
    @resource = resource
    @root_term = {}
    @all_terms, @industry_terms, @industries, @sectors = [], [], [], []
  end

  def import
    xml = extract_xml_from_zip
    parse_terms_from_xml(xml)

    @all_terms.each { |term| @industry_terms.push(term) if term_in_industries_taxonomy?(term) }
    extract_industries_and_sectors
    @sectors = find_parent_industries

    update_or_add_industries
    update_or_add_sectors
    delete_old_terms
  end

  def delete_old_terms
    Industry.all.each do |db_industry|
      if @industries.find { |protege_industry| protege_industry[:protege_id] == db_industry.protege_id } == nil
        db_industry.destroy
      end
    end

    Sector.all.each do |db_sector|
      if @sectors.find { |protege_sector| protege_sector[:protege_id] == db_sector.protege_id } == nil
        db_sector.destroy
      end
    end
  end

  def update_or_add_industries
    @industries.each do |term|
      if Industry.exists?(protege_id: term[:protege_id])
        industry = Industry.find_by(protege_id: term[:protege_id])
        industry.update(name: term[:name])
      else
        industry = Industry.create(protege_id: term[:protege_id], name: term[:name])
      end

    end
  end

  def update_or_add_sectors
    @sectors.each do |term|
      if Sector.exists?(protege_id: term[:protege_id])
        sector = Sector.find_by(protege_id: term[:protege_id])
        sector.update(name: term[:name])
      else
        sector = Sector.create(protege_id: term[:protege_id], name: term[:name])
      end

      update_or_add_industry_and_sector_mappings(term)
    end
  end

  def update_or_add_industry_and_sector_mappings(term)
    term[:industry_ids].each do |industry_id|  
      sector = Sector.find_by(protege_id: term[:protege_id])
      industry = Industry.find_by(protege_id: industry_id)
      sector.industries << industry unless sector.industries.include?(industry)
      industry.sectors << sector unless industry.sectors.include?(sector)
    end
  end

  def extract_industries_and_sectors
    @industry_terms.each do |term|
      if term[:parent_ids] == [@root_term[:protege_id]]
        @industries.push(term)
      else
        @sectors.push(term.merge({industry_ids: []}))
      end
    end
  end

  def term_in_industries_taxonomy?(term)
    if term[:parent_ids].include? @root_term[:protege_id]
      return true
    elsif ['skos:Concept', 'Concept Scheme', 'Collection'].include?(term[:name]) || term[:parent_ids] == []
      return false
    else
      @all_terms.each do |t|
        return term_in_industries_taxonomy?(t) if term[:parent_ids].include?(t[:protege_id])
      end
    end
  end

  def extract_xml_from_zip
    open('temp.zip', 'wb') { |file| file << open(@resource).read }

    content = ""
    Zip::File.open('temp.zip') do |zip_file|
      zip_file.each do |entry|
        if entry.name.end_with?('.owl')
          content = entry.get_input_stream.read
        end
      end
    end

    File.delete('temp.zip')
    Nokogiri::XML(content)
  end

  def parse_terms_from_xml(xml)
    classes = xml.xpath('//owl:Class')
    classes.each do |owl_class|
      if owl_class.xpath('./rdfs:label').text == "Industries"
        @root_term = { name: owl_class.xpath('./rdfs:label').text,
                       protege_id: owl_class.attr('rdf:about'),
                       parent_ids: [owl_class.xpath('./rdfs:subClassOf')[0].attr('rdf:resource')] }
      else
        @all_terms << {  name: owl_class.xpath('./rdfs:label').text,
                     protege_id: owl_class.attr('rdf:about'),
                     parent_ids: parse_parent_ids(owl_class) }
      end
    end
  end

  def parse_parent_ids(owl_class)
    parents = owl_class.xpath('./rdfs:subClassOf')
    ids = []
    parents.map do |parent|
      if !parent.attr('rdf:resource').nil?
        ids.push(parent.attr('rdf:resource'))
      end  
    end
    ids
  end

  def find_parent_industries
    sorted_sectors = find_industries_for_top_level_sectors
    sector_temp = []

    while @sectors.count > 0 do 
      sorted_sectors.concat(sort_nested_sectors(sorted_sectors, sector_temp))
      sector_temp.clear
    end

    sorted_sectors
  end

  def find_industries_for_top_level_sectors
    sorted_sectors = []
    @sectors.each do |sector|
      sector[:parent_ids].delete_if do |parent|
        if @industries.any? {|industry| industry[:protege_id] == parent}
          sector[:industry_ids].push(parent)
          true
        else
          false
        end
      end
      sorted_sectors.push(sector) if sector[:parent_ids].count == 0
    end

    @sectors.reject!{|sector| sorted_sectors.include? sector}
    sorted_sectors
  end

  def sort_nested_sectors(sorted_sectors, sector_temp)
      @sectors.each do |sector|
        sector[:parent_ids].delete_if do |parent|
          if sorted_sectors.any? {|ss| ss[:protege_id] == parent}
            sector[:industry_ids].concat(sorted_sectors.find{|ss| ss[:protege_id] == parent}[:industry_ids])
            true
          else
            false
          end
        end
        sector_temp.push(sector) if sector[:parent_ids].count == 0
      end

      @sectors.reject!{|sector| sector_temp.include? sector}
      sorted_sectors.concat(sector_temp)
      sorted_sectors
  end

end
