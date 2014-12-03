class UserBelief < ActiveRecord::Base
  belongs_to :user
  belongs_to :belief

  after_save do
    self.update_average_conviction
  end

  def update_average_conviction
    total = 0
    self.belief.user_beliefs.each do |ub|
      total += ub.conviction
    end
    self.belief.avg_conviction = total/belief.user_beliefs.count
    self.belief.save
  end

end
