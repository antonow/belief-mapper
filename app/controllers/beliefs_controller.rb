class BeliefsController < ApplicationController
  def index
    unless user_signed_in?
      redirect_to '/'
    else
      if params[:query].present?
        @results = Belief.search(params[:query]) # , page: params[:page]
      else
        @beliefs = Belief.all
        @connections = Connection.all
      end
    end
  end

  def filter
    # relevant_users = []
    # @beliefs = []
    # User.all.each do |user|
    #   if user.demographic.gender == 'f'
    #     relevant_users << user
    #     user.beliefs.each do |belief|
    #       @beliefs << Belief.new()
    #     end
    # end

    # @beliefs = []
    # Belief.all.each do |belief|
    #   belief.users.each do |user|
    #     user.beliefs.each do |a_belief| #if user.demographic.gender == 'f'
    #       @beliefs << a_belief
    #     end
    #   end
    # end
    # puts "=============================="
    # puts @beliefs
    # puts "=============================="

  @beliefs = Belief.all
  @connections = Connection.all

  end

  def search
    raise params.to_s
    @results = Belief.search(params)
  end

  def autocomplete
    render json: Belief.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
  end

end
