class CreateEmenus < ActiveRecord::Migration
  def change
    create_table :emenus do |t|
      t.references :sector, index: true
      t.string :name
      t.timestamps
    end
    add_index :emenus, :name, unique: true
  end
end
