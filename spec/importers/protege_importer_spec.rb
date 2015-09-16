require 'spec_helper'

describe ProtegeImporter do
  describe '#import' do
    
    before(:all) do
      Sector.destroy_all
      Industry.destroy_all
      fixtures_dir = "#{Rails.root}/spec/fixtures/protege_importer" 
      resource = "#{fixtures_dir}/test_data.zip" 
      importer = ProtegeImporter.new(resource)
      @entry_hash = YAML.load_file("#{fixtures_dir}/results.yaml")

      deletable_industry = Industry.create(name: 'deletable industry', protege_id: 1337)
      updateable_industry = Industry.create(name: @entry_hash[0]["name"], protege_id: @entry_hash[0]["protege_id"])
      updateable_sector = Sector.create(name: @entry_hash[1]["name"], protege_id: @entry_hash[1]["protege_id"])
      updateable_sector.industries << updateable_industry
      deletable_sector = Sector.create(name: 'Deletable Sector', protege_id: 13372)

      importer.import
 
      @industry1 = Industry.find_by(name: 'Construction')
      @industry2 = Industry.find_by(name: 'Industrial Materials')
      @sector1 = Sector.find_by(name: 'Metals')
      @sector2 = Sector.find_by(name: 'Building Products and Equipment')
      @sector3 = Sector.find_by(name: 'Iron and Steel')
    end

    it 'creates the correct number of Active Record Industries and Sectors' do
      expect(Industry.count).to eq(2)
      expect(Sector.count).to eq(3)
    end

    it 'creates the correct names and protege_ids for an Industry' do
      expect(@industry1.name).to eq(@entry_hash[0]["name"])
      expect(@industry1.protege_id).to eq(@entry_hash[0]["protege_id"])
    end
      
    it 'creates the correct names and protege_ids for a Sector' do
      expect(@sector1.name).to eq(@entry_hash[2]["name"])
      expect(@sector1.protege_id).to eq(@entry_hash[2]["protege_id"])
    end

    it 'creates the correct Industry to Sector mappings for Construction' do
      ids = @industry1.sectors.map{ |s| s.id }
      expected_ids = [@sector1.id, @sector2.id, @sector3.id]
      expect(ids).to match_array(expected_ids)
    end

    it 'creates the correct Sector to Industry mappings for Metals' do
      ids = @sector1.industries.map{ |i| i.id }
      expected_ids = [@industry1.id, @industry2.id]
      expect(ids).to match_array(expected_ids)
    end

  end
end
