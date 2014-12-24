class UserBeliefsController < ApplicationController

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
    user_belief = UserBelief.find_or_initialize_by(belief: belief, user: user)
    user_belief.conviction = params[:conviction]
    user_belief.skipped = false

    if user_belief.save!
      if user_belief.conviction > 5
        generate_new_connections(user_belief)
        belief.user_count += 1
        belief.save
      end

      redirect_to users_path
    else
      redirect_to 'error'
    end
  end

  def destroy
    if params[:user_belief] != nil
      belief = Belief.find_by(name: params[:user_belief][:name])
    else
      belief = Belief.find(params[:id])
    end
    user_belief = current_user.user_beliefs.where(belief: belief).first.destroy
    belief.user_count -= 1
    belief.save
    redirect_to :back
  end

end

