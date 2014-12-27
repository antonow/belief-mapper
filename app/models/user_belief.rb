class UserBelief < ActiveRecord::Base
  belongs_to :user
  belongs_to :belief


  after_save do
    self.update_average_conviction unless self.skipped
    self.user.increment_questions_answered
  end

  after_destroy do
    self.update_average_conviction
  end

  def update_average_conviction
    belief = self.belief
    current_average = belief.avg_conviction
    current_total = belief.user_count

    belief.avg_conviction = (current_total * current_average + self.conviction) / (current_total + 1)
    belief.save!
  end

  def calculate_average_conviction # more precise but takes much longer
    total = 0
    self.belief.user_beliefs.where(skipped: false).each do |ub|
      total += ub.conviction
    end
    if belief.user_beliefs.count == 0
      belief.avg_conviction = 0
    else
      self.belief.avg_conviction = total/belief.user_beliefs.count
    end
    self.belief.save
  end

end
