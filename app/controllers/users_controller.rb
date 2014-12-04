class UsersController < ApplicationController
  def index
    b = current_user.held_beliefs
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

  def skip
      render :partial => "/beliefs/main_topbar"
  end

  def show
      @user = User.find_by(unique_url: params[:id])

      b = @user.held_beliefs
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
