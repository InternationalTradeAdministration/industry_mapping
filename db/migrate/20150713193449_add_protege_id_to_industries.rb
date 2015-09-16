class AddProtegeIdToIndustries < ActiveRecord::Migration
  def change
    add_column :industries, :protege_id, :string
  end
end
