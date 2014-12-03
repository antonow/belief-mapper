class UserBeliefsController < ApplicationController
  # include ApplicationHelper
  include UsersBeliefsHelper

  require 'faker'

  def create
    belief = Belief.find(params[:belief])
    if (current_user == nil)
      user = User.create!(:email => Faker::Internet.email, :password => 'password', :password_confirmation => 'password')
      sign_in(user)
    else
      user = current_user
    end
    user_belief = UserBelief.new(belief: belief, user: user, conviction: params[:conviction])
    if user_belief.save!
      if user_belief.conviction > 5
        generate_new_connections(user_belief)
        belief.user_count += 1
        belief.save
      end
      # if @count = user.beliefs.count >= 3
      redirect_to :back
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

