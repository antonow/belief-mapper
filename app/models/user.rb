class User < ActiveRecord::Base
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
    self.user_beliefs.order("conviction DESC").where("conviction > ?", 5).limit(DEFAULT_MAX_BELIEFS).map { |user_belief| Belief.find(user_belief.belief_id) }
  end

  def starred_beliefs
    # The line below gets all starred beliefs - I'm hard-coding to avoid making too many database calls
    # Belief.where(starred: true).order('id ASC').pluck(:id)

    [5, 6, 7, 11, 12, 13, 22, 26, 29, 32, 33, 37, 38, 40, 43, 46, 48, 50, 53, 55, 56, 57, 58, 59, 60, 63, 64, 65, 66, 67, 70, 71, 72, 73, 74, 79, 80, 81, 85, 86, 87, 88, 89, 90, 91, 92, 96, 97, 98, 99, 101, 102, 104, 106, 107, 108, 109, 111, 112, 113, 116, 119, 120, 121, 123, 125, 126, 127, 128, 129, 131, 132, 136, 141, 145, 148, 152, 156, 157, 158, 159, 161, 163, 165, 166, 167, 170, 171, 174, 175, 177, 178, 179, 180, 182, 183, 185, 186, 187, 188, 191, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 206, 207, 209, 210, 211, 213, 219, 222, 223, 225, 227, 228, 230, 231, 233, 234]
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
    ((self.answered_questions.to_f / starred_beliefs.count.to_f) * 100).to_i.to_s + "%"
  end

  def increment_questions_answered
    self.update_attribute(:answered_questions, self.answered_questions + 1)
  end

end
