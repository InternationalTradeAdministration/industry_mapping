class RenameEmenuToTopic < ActiveRecord::Migration
  def change
    rename_table :emenus, :topics
  end
end
