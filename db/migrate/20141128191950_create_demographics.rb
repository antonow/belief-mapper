class CreateDemographics < ActiveRecord::Migration
  def change
    create_table :demographics do |t|
      t.string  :gender
      t.integer :age
      t.string  :religion
      t.string  :country
      t.string  :state
      t.string  :education_level
      t.belongs_to :user

      t.timestamps
    end
  end
end
