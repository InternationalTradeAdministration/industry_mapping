class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children, id: false do |t|
      t.integer 'term_a_id'
      t.integer 'term_b_id'
    end
  end
end
