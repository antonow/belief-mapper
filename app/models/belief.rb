class Belief < ActiveRecord::Base
  belongs_to :category
  has_many :user_beliefs, -> { includes(:user) }
  has_many :users, through: :user_beliefs
  has_many :demographics, through: :users

  def self.search(query)
    where("definition like ? OR name like ?", "%#{query}%", "%#{query}%")
  end

  def stats_for(query, value)
    self.demographics.where(query => value).count
  end

  def list_top_connections
    Connection.connected_belief_strengths(self)
  end
end
