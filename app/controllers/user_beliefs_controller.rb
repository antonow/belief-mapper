class UserBeliefsController < ApplicationController
  skip_before_filter :require_login, :only=>[:create]

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
    prev_conviction = user_belief.conviction unless user_belief.new_record?
    user_belief.conviction = params[:conviction]
    user_belief.skipped = false

    if user_belief.save!
      if user_belief.conviction > 5
        belief.user_count += 1
        belief.save
        generate_new_connections(user_belief)
        # user.held_belief_ids << user_belief.belief_id
      # else
        # user.not_at_all_belief_ids << user_belief.belief_id
      end
      redirect_to users_path
    end

  end

  def destroy
    if params[:user_belief] != nil
      belief = Belief.find_by(name: params[:user_belief][:name])
    else
      belief = Belief.friendly.find(params[:id])
    end
    user_belief = current_user.user_beliefs.find_by(belief: belief)
    generate_new_connections(user_belief, :down => true)
    user_belief.destroy

    belief.user_count -= 1 unless belief.user_count <= 0
    belief.save
    redirect_to :back
  end

end

