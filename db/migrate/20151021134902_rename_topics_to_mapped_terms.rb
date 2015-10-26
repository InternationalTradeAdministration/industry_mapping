class RenameTopicsToMappedTerms < ActiveRecord::Migration
  def change
    rename_table :topics, :mapped_terms
  end
end
