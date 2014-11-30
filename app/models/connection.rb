class Connection < ActiveRecord::Base
  belongs_to :belief_1, class_name: "Belief", foreign_key: "belief_1_id"
  belongs_to :belief_2, class_name: "Belief", foreign_key: "belief_2_id"
end
