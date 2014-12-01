class UserBeliefsController < ApplicationController
  include ApplicationHelper
  require 'faker'

  def create
    belief = Belief.find(params[:belief])
    # @count = 0
    user = (current_user == nil) ? User.create!(:email => Faker::Internet.email, :password => 'password', :password_confirmation => 'password') : current_user
    session[:user_id] = user.id
    user_belief = UserBelief.new(belief: belief, user: user, conviction: params[:conviction])
    if user_belief.save!
      if user_belief.conviction > 5
        create_connections_for(belief)
        belief.user_count += 1
      end
      # if @count = user.beliefs.count >= 3
      redirect_to beliefs_path
      # end
    else
      redirect_to 'error'
    end
  end

  def destroy
    if params[:user_belief] != nil
      belief = Belief.find_by(name: params[:user_belief][:name])
    else
      belief = UserBelief.find(params[:id])
    end
    user_belief = current_user.user_beliefs.where(belief: belief).first.destroy
    redirect_to :back
  end

  # def create_belief?
  #   params[:conviction].to_i > 5
  # end
end

