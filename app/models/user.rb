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

  def unexamined_beliefs
    return Belief.all - self.beliefs
  end
end
