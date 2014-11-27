class Belief < ActiveRecord::Base
  has_many :user_beliefs
  has_many :users, through: :user_beliefs
end
