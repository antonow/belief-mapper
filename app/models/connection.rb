class Connection < ActiveRecord::Base
  belongs_to :belief_1, class_name: "Belief", foreign_key: "belief_1_id"
  belongs_to :belief_2, class_name: "Belief", foreign_key: "belief_2_id"

  def self.for_a_belief_id(belief_id)
    where("belief_1_id = ? OR belief_2_id = ?", belief_id, belief_id)
  end

  def self.connected_belief_strengths(belief)
    connection_strengths = {}
    belief_id = belief.id
    for_a_belief_id(belief_id).each do |conn|
      linked_belief_id = (conn.belief_1_id != belief_id) ? conn.belief_1_id
                                                         : conn.belief_2_id
      connection_strengths[linked_belief_id] = conn.strong_connections
    end
    linked_beliefs = Belief.find(connection_strengths.keys)
    linked_beliefs.map {|belief| [belief, connection_strengths[belief.id]]}.sort_by(&:last).reverse
  end
end
