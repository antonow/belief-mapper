class Category < ActiveRecord::Base
  has_many :beliefs

  extend FriendlyId
	friendly_id :name, use: :slugged

  def total_beliefs
    self.beliefs.count
  end
end
