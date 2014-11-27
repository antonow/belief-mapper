class CreateBeliefs < ActiveRecord::Migration
  def change
    create_table :beliefs do |t|
      t.string :name
      t.string :definition
      t.string :resource

      t.timestamps
    end
  end
end
