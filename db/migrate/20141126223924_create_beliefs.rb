class CreateBeliefs < ActiveRecord::Migration
  def change
    create_table :beliefs do |t|
      t.string :name
      t.string :definition
      t.string :resource
      t.integer :user_count, :default => 0
      t.integer :avg_conviction

      t.timestamps
    end
  end
end
