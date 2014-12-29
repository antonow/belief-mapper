class AddSlugsToCategoriesAndBeliefs < ActiveRecord::Migration
  def change
  	add_column :categories, :slug, :string
  	add_index :categories, :slug, unique: true

  	add_column :beliefs, :slug, :string
  	add_index :beliefs, :slug, unique: true
  end
end
