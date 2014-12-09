class AddSortedDemographicsColumns < ActiveRecord::Migration
  def change
  	add_column :demographics, :gender_sorted, :string
  	add_column :demographics, :religion_sorted, :string
  end
end
