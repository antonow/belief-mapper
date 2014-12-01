class Belief < ActiveRecord::Base
  has_many :user_beliefs
  has_many :users, through: :user_beliefs
  has_many :connections, foreign_key: 'belief_1_id'
  has_many :connections, foreign_key: 'belief_2_id'

  searchkick text_start: [:name]

end
