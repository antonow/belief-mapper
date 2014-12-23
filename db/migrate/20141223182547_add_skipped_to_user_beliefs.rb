class AddSkippedToUserBeliefs < ActiveRecord::Migration
  def change
  	add_column :user_beliefs, :skipped, :boolean, :default => false
  end
end
