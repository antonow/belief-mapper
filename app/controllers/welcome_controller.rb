class WelcomeController < ApplicationController

  def index
    @connection_hash = {}
    Belief.all[13].connections.order('belief_1_id ASC').all.uniq{|x| x.id}.each do |connection|
      count = Connection.all.where(belief_1_id: connection.belief_1.id, belief_2_id: connection.belief_2.id).count
      @connection_hash["#{connection.belief_1.name} and #{connection.belief_2.name}"] = count
    end
    return @connection_hash
  end
end
