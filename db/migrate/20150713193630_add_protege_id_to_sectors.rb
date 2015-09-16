class AddProtegeIdToSectors < ActiveRecord::Migration
  def change
    add_column :sectors, :protege_id, :string
  end
end
