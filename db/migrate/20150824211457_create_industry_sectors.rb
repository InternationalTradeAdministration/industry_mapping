class CreateIndustrySectors < ActiveRecord::Migration
  def change
    remove_reference :sectors, :industry, index: true

    create_table :industry_sectors, id: false do |t|
      t.belongs_to :industry, index: true
      t.belongs_to :sector, index: true
    end
  end
end
