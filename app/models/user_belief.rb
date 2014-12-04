class UserBelief < ActiveRecord::Base
  belongs_to :user
  belongs_to :belief

  after_save do
    self.update_average_conviction
  end

  after_destroy do
    self.update_average_conviction
  end

  def update_average_conviction
    total = 0
    self.belief.user_beliefs.each do |ub|
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
