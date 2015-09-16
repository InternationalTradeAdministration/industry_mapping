class AddSourceIdToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :source_id, :integer, null: false
    add_index :topics, [:source_id, :name], unique: true

    reversible do |dir|
      dir.up do
        market_research_source = Source.find_or_create_by(name: 'MarketResearch')
        execute "UPDATE topics SET source_id = #{market_research_source.id}"
      end
    end
  end
end
