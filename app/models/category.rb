class Category < ActiveRecord::Base
  has_many :beliefs

  def total_beliefs
    self.beliefs.count
  end
end
