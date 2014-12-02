class UsersController < ApplicationController
  def index
    b = current_user.beliefs
        @beliefs = []
        b.each {|bel| @beliefs << bel}
        @connections = []
        user_belief_ids = b.pluck(:id)
        # @beliefs.each do |belief|
        @connections = Connection.where(:belief_1_id => user_belief_ids, :belief_2_id => user_belief_ids)
        @connections = @connections.to_a.compact
        @connections
        @beliefs
  end
end
