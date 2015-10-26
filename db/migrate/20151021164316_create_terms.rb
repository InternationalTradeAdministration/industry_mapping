class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :name
      t.string :protege_id
      t.timestamps
    end
  end
end
