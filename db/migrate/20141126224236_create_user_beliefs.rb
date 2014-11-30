class CreateUserBeliefs < ActiveRecord::Migration
  def change
    create_table :user_beliefs do |t|
      t.belongs_to :user, index: true
      t.belongs_to :belief, index: true
      t.integer    :conviction

      t.timestamps
    end
  end
end
