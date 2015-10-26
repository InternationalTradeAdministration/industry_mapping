class Taxonomy < ActiveRecord::Base
  has_and_belongs_to_many(:terms, join_table: 'terms_joined_taxonomies')
  validates :name, presence: true, uniqueness: true

  def self.update_taxonomies_from_protege(root_terms)
    update_or_add_taxonomies(root_terms)
    delete_old_taxonomies(root_terms)
  end

  def self.update_or_add_taxonomies(root_terms)
    root_terms.each do |term|
      if Taxonomy.exists?(protege_id: term[:protege_id])
        taxonomy = Taxonomy.find_by(protege_id: term[:protege_id])
        taxonomy.update(name: term[:name])
      else
        taxonomy = Taxonomy.create(protege_id: term[:protege_id], name: term[:name])
      end
    end
  end

  def self.delete_old_taxonomies(root_terms)
    Taxonomy.all.each do |db_taxonomy|
      if root_terms.find { |protege_taxonomy| protege_taxonomy[:protege_id] == db_taxonomy.protege_id }.nil?
        db_taxonomy.destroy
      end
    end
  end
end
