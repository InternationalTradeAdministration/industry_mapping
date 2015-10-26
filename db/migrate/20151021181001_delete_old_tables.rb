class DeleteOldTables < ActiveRecord::Migration
  def change
    drop_table :industries
    drop_table :sectors
    drop_table :industry_sectors
    drop_table :industry_sector_topics
  end
end
