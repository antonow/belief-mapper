class UserBelief < ActiveRecord::Base
  belongs_to :user
  belongs_to :belief


  after_save do
    self.update_average_conviction unless self.skipped
    self.user.increment_questions_answered
  end

  after_destroy do
    self.update_average_conviction(:down => true)
  end

  def update_average_conviction(options={})
    default_options = {
      :down => :false
    }

    belief = self.belief
    current_total = belief.user_count
    current_average = belief.avg_conviction

    if options[:down]
      if current_total <= 1
        belief.avg_conviction = 0
      else
        belief.avg_conviction = (current_total * current_average - self.conviction) / (current_total - 1)
      end
    else
      if current_total <= 0
        belief.avg_conviction = self.conviction
      else
        belief.avg_conviction = (current_total * current_average + self.conviction) / (current_total + 1)
      end
    end
    belief.save!
  end

end
