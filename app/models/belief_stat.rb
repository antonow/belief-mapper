class BeliefStat < ActiveRecord::Base
	belongs_to :stat
	belongs_to :belief
end
