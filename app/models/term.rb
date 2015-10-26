class Term < ActiveRecord::Base
  has_and_belongs_to_many(:children,
                          class_name:              'Term',
                          join_table:              'children',
                          foreign_key:             'term_a_id',
                          association_foreign_key: 'term_b_id')

  has_and_belongs_to_many(:parents,
                          class_name:              'Term',
                          join_table:              'parents',
                          foreign_key:             'term_b_id',
                          association_foreign_key: 'term_a_id')

  has_and_belongs_to_many(:mapped_terms, join_table: 'terms_joined_mapped_terms')

  has_and_belongs_to_many(:taxonomies, join_table: 'terms_joined_taxonomies')

  validates :protege_id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  def self.update_terms_from_protege(processed_terms)
    update_or_add_terms(processed_terms)
    delete_old_terms(processed_terms)
    set_term_relationships(processed_terms)
  end

  def self.update_or_add_terms(processed_terms)
    processed_terms.each do |term|
      if Term.exists?(protege_id: term[:protege_id])
        term = Term.find_by(protege_id: term[:protege_id])
        term.update(name: term[:name])
      else
        term = Term.create(protege_id: term[:protege_id], name: term[:name])
      end
    end
  end

  def self.delete_old_terms(processed_terms)
    Term.all.each do |db_term|
      if processed_terms.find { |protege_term| protege_term[:protege_id] == db_term.protege_id }.nil?
        db_term.destroy
      end
    end
  end

  def self.set_term_relationships(processed_terms)
    processed_terms.each do |term|
      saved_term = Term.find_by(protege_id: term[:protege_id])
      parent_terms = term[:parents].map { |parent| Term.find_by(name: parent) }.compact
      child_terms = term[:children].map { |child| Term.find_by(name: child) }.compact
      taxonomies = term[:taxonomies].map { |taxonomy| Taxonomy.find_by(name: taxonomy) }.compact

      saved_term.parents = parent_terms unless parent_terms.empty?
      saved_term.children = child_terms unless child_terms.empty?
      saved_term.taxonomies = taxonomies unless taxonomies.empty?
    end
  end
end
