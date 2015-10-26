class CreateTermsJoinedMappedTerms < ActiveRecord::Migration
  def change
    create_table :terms_joined_mapped_terms, id: false do |t|
      t.belongs_to :term, index: true
      t.belongs_to :mapped_term, index: true
    end
  end
end
