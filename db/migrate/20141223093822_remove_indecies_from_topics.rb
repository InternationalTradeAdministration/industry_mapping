class RemoveIndeciesFromTopics < ActiveRecord::Migration
  def up
    remove_index :topics, name: :index_topics_on_name
    remove_index :topics, name: :index_topics_on_sector_id
  end

  def down
    add_index :topics, :sector_id
    add_index :topics, :name, unique: true
  end
end
