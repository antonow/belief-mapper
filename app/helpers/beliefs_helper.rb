module BeliefsHelper

	def starred_beliefs
    # The line below gets all starred beliefs - I'm hard-coding to avoid making too many database calls
    # Belief.where(starred: true).order('id ASC').pluck(:id)
		[5, 6, 7, 11, 12, 13, 22, 26, 29, 32, 33, 37, 38, 40, 43, 46, 48, 50, 53, 55, 56, 57, 58, 59, 60, 63, 64, 65, 66, 67, 70, 71, 72, 73, 74, 79, 80, 81, 85, 86, 87, 88, 89, 90, 91, 92, 96, 97, 98, 99, 101, 102, 104, 106, 107, 108, 109, 111, 112, 113, 116, 119, 120, 121, 123, 125, 126, 127, 128, 129, 131, 132, 136, 141, 145, 148, 151, 152, 156, 157, 158, 159, 161, 163, 165, 166, 167, 170, 171, 174, 175, 177, 178, 179, 180, 182, 183, 185, 186, 187, 188, 191, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 206, 207, 209, 210, 211, 213, 219, 222, 223, 225, 227, 228, 230, 231, 233, 234]
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
