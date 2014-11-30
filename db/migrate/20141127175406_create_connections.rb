class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :belief_1_id
      t.integer :belief_2_id
      t.integer :count, :default => 0

      t.timestamps
    end
  end
end
