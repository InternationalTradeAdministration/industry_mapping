require 'spec_helper'

describe ProtegeImporter do
  describe '#import' do
    before(:all) do
      Term.destroy_all
      Taxonomy.destroy_all
      fixtures_dir = "#{Rails.root}/spec/fixtures/protege_importer"
      resource = "#{fixtures_dir}/test_data.zip"
      importer = ProtegeImporter.new(resource)
      @expected_terms = YAML.load_file("#{fixtures_dir}/terms.yaml")
      @expected_taxonomies = YAML.load_file("#{fixtures_dir}/taxonomies.yaml")

      deletable_term = Term.create(name: 'deletable term', protege_id: 1337)
      updateable_term = Term.create(name: 'Aerospace and Defense', protege_id: 'http://webprotege.stanford.edu/R8CoATsjiZSLAZF4Aaz6kK6')

      updateable_taxonomy = Taxonomy.create(name: 'Industries', protege_id: 'http://webprotege.stanford.edu/R79uIjoQaQ9KzvJfyB1H7Ru')
      deletable_taxonomy = Taxonomy.create(name: 'deletable taxonomy', protege_id: 1337)

      importer.import(['Industries', 'Countries', 'Topics', 'World Regions', 'Trade Regions'])

      @terms = Term.all
      @taxonomies = Taxonomy.all
    end

    it 'creates the correct number of Active Record Terms and Taxonomies' do
      expect(Term.count).to eq(9)
      expect(Taxonomy.count).to eq(5)
    end

    it 'creates the correct names and protege_ids for all Terms' do
      expect(@terms.map { |t| t[:name] }).to match_array(@expected_terms.map { |t| t['name'] })
      expect(@terms.map { |t| t[:protege_id] }).to match_array(@expected_terms.map { |t| t['protege_id'] })
    end

    it 'creates the correct names and protege_ids for all Taxonomies' do
      expect(@taxonomies.map { |t| t[:name] }).to match_array(@expected_taxonomies.map { |t| t['name'] })
      expect(@taxonomies.map { |t| t[:protege_id] }).to match_array(@expected_taxonomies.map { |t| t['protege_id'] })
    end

    it 'creates the correct Parent/Child relationships for a Term' do
      term1 = Term.find_by(name: 'Aerospace and Defense')
      term2 = Term.find_by(name: 'Aviation')

      expect(term1.children).to include(term2)
      expect(term2.parents).to include(term1)
    end

    it 'creates the correct relationships between a Term and Taxonomy' do
      term = Term.find_by(name: 'Aerospace and Defense')
      taxonomy = Taxonomy.find_by(name: 'Industries')

      expect(term.taxonomies).to include(taxonomy)
      expect(taxonomy.terms).to include(term)
    end
  end
end
