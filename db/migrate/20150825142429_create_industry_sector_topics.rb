class CreateIndustrySectorTopics < ActiveRecord::Migration
  def change
    remove_reference :topics, :sector, index: true

    create_table :industry_sector_topics, id: false do |t|
      t.belongs_to :industry, index: true
      t.belongs_to :sector, induex: true
      t.belongs_to :topic, index: true
    end
  end
end
