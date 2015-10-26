class CreateTaxonomies < ActiveRecord::Migration
  def change
    create_table :taxonomies do |t|
      t.string :name
      t.string :protege_id
      t.timestamps
    end
    create_table :terms_joined_taxonomies, id: false do |t|
      t.belongs_to :term, index: true
      t.belongs_to :taxonomy, index: true
    end
  end
end
