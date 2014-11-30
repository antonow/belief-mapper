class BeliefsController < ApplicationController
  def index
    @beliefs = Belief.all
    @connections = Connection.all
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
end
