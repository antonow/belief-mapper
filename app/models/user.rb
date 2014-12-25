class User < ActiveRecord::Base

  include BeliefsHelper

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one  :demographic
  has_many :user_beliefs
  has_many :beliefs, through: :user_beliefs

  before_create :assign_short_url

   def assign_short_url
      random_array = (0..9).to_a.map(&:to_s) + ("a".."z").to_a
      random_string = ""
      10.times { random_string += random_array.sample}
      self.unique_url = random_string
      # self.save
   end

  def username
    if self.active
      self.email.match(/.+?(?=@)/)
    else
      "guest"
    end
  end

  def held_beliefs
    self.beliefs.order("name ASC").where("conviction > ?", 5)
  end

  def held_beliefs_by_conviction
    self.user_beliefs.order("conviction DESC").where("conviction > ?", 5).limit(USER_MAX_BELIEFS).map { |user_belief| Belief.find(user_belief.belief_id) }
  end

  def unexamined_beliefs
    starred_beliefs - beliefs_answered
  end

  # returns every belief that the user has answered.
  def beliefs_answered
    self.beliefs.pluck(:id)
  end

  # returns the percentage of questions answered.
  def percent_answered
    percent_answered_int.to_s + "%"
  end

  def percent_answered_int
    ((self.answered_questions.to_f / starred_beliefs.count.to_f) * 100).to_i
  end

  def increment_questions_answered
    self.update_attribute(:answered_questions, self.answered_questions + 1)
  end

end
