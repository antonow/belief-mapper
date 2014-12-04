class UsersController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        @beliefs = []
        @connections = []

        @beliefs = current_user.held_beliefs
        belief_ids = @beliefs.pluck(:id)
        @connections = Connection.where(:belief_1_id => belief_ids, :belief_2_id => belief_ids)
        @connections = @connections.to_a.compact
      }
      format.html {}
    end
        # b.each {|bel| @beliefs << bel}
        # user_belief_ids = b.pluck(:id)
        # # @beliefs.each do |belief|
        # @connections
        # @beliefs
  end

  def skip
      render :partial => "/beliefs/main_topbar"
  end

  def show
    respond_to do |format|
      format.json {
        @user = User.find_by(unique_url: params[:id])
        @beliefs = []
        @connections = []

        @beliefs = @user.held_beliefs
        belief_ids = @beliefs.pluck(:id)
        @connections = Connection.where(:belief_1_id => belief_ids, :belief_2_id => belief_ids)
        @connections = @connections.to_a.compact
      }
      format.html {}
    end
  end

end
