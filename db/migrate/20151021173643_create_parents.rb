class CreateParents < ActiveRecord::Migration
  def change
    create_table :parents, id: false do |t|
      t.integer 'term_b_id'
      t.integer 'term_a_id'
    end
  end
end
