class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.references :industry, index: true
      t.string :name

      t.timestamps
    end
  end
end
