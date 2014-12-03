class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one  :demographic
  has_many :user_beliefs
  has_many :beliefs, through: :user_beliefs

  def held_beliefs
    return self.beliefs.where("conviction > ?", 5)
  end

  def starred_beliefs
    return Belief.where(starred: true)
  end

  def unexamined_beliefs
    return starred_beliefs - self.beliefs
  end

  # returns every belief that the user has answered.
  def beliefs_answered
    return self.beliefs
  end

  # returns the percentage of questions answered.
  def percent_answered
    ((self.beliefs_answered.count.to_f / starred_beliefs.count.to_f) * 100).to_i.to_s + "%"
  end



end
