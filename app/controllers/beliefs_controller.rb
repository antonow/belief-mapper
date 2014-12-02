class BeliefsController < ApplicationController
  def index
    unless user_signed_in?
      redirect_to '/'
    else
      if params[:query].present?
        @results = Belief.search(params[:query]) # , page: params[:page]
      elsif params[:user].present?
        redirect_to '/users'
        b = current_user.beliefs
        @beliefs = []
        b.each {|bel| @beliefs << bel}
        @connections = []
        user_belief_ids = b.pluck(:id)
        # @beliefs.each do |belief|
        @connections = Connection.where(:belief_1_id => user_belief_ids, :belief_2_id => user_belief_ids)
        @connections = @connections.to_a.compact
        @rout
        @connections
        @beliefs
      else
        @beliefs = Belief.all
        @connections = Connection.all
      end
    end
  end


  def user
    b = current_user.beliefs
    @beliefs = []
    b.each {|bel| @beliefs << bel}
    @connections = []
    user_belief_ids = b.pluck(:id)
    # @beliefs.each do |belief|
    @connections = Connection.where(:belief_1_id => user_belief_ids, :belief_2_id => user_belief_ids)
    @connections = @connections.to_a.compact
    # @connections.uniq
    @beliefs
  end

  def filter
  @beliefs = Belief.all
  @connections = Connection.all
  end

  def show
    @belief = Belief.find(params[:id])
  end

  def search
    raise params.to_s
    @results = Belief.search(params)
  end

  def autocomplete
    render json: Belief.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
  end

  def list
    @results = Belief.all
    render "list"
  end

end
