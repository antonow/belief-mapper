class CreateBeliefs < ActiveRecord::Migration
  def change
    create_table :beliefs do |t|
      t.string :title
      t.string :resource

      t.timestamps
    end
  end
end
