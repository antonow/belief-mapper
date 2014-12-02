class Belief < ActiveRecord::Base
  belongs_to :category
  has_many :user_beliefs
  has_many :users, through: :user_beliefs
  has_many :demographics, through: :users
  has_many :connections, foreign_key: 'belief_1_id'
  has_many :connections, foreign_key: 'belief_2_id'

  def self.search(query)
    where("definition like ? OR name like ?", "%#{query}%", "%#{query}%")
  end

  def find_stats(query, value)
    raise User.where(belief: self)
    user_beliefs = UserBelief.all.where(belief: self)
    user_beliefs.where(user.demographic.eval(query) + ' = ?', value)
    # demographics = []
    # user_beliefs.all.each do |user_belief|
    #   demographics << user_belief.user.demographic
    # end

    # demographics.where(query + ' = ?', value).count
  end



  def stats_for(query, value)
    return self.demographics.where(query.to_sym => value).count
  end





end
