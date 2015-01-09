module BeliefsHelper

	def starred_beliefs
    # The line below gets all starred beliefs - I'm hard-coding to avoid making too many database calls
    # Belief.where(starred: true).order('id ASC').pluck(:id)
		[6, 7, 11, 12, 13, 18, 22, 26, 32, 33, 37, 38, 40, 43, 46, 48, 50, 53, 55, 57, 58, 59, 60, 63, 64, 65, 67, 71, 72, 73, 79, 80, 81, 85, 86, 87, 88, 89, 90, 92, 96, 97, 98, 99, 101, 102, 104, 107, 108, 109, 111, 113, 116, 120, 121, 125, 126, 127, 128, 129, 131, 136, 139, 141, 145, 146, 148, 151, 152, 156, 157, 158, 159, 161, 163, 164, 165, 166, 167, 168, 170, 174, 175, 177, 179, 180, 182, 183, 185, 186, 187, 189, 195, 197, 199, 200, 201, 202, 203, 204, 206, 207, 209, 210, 211, 213, 216, 219, 222, 223, 225, 227, 228, 230, 231, 233, 234, 237, 238, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 254, 255]
  end

  def calculate_average_conviction
    if self.user_beliefs.count == 0
      self.avg_conviction = 0
    else
      total = 0
      self.user_beliefs.where(skipped: false).each do |ub|
        total += ub.conviction
      end
      self.avg_conviction = total / self.user_beliefs.count
    end
    self.save
  end

end
