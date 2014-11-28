class UserBeliefsController < ApplicationController
  def create
    belief = Belief.find(params[:belief])
    if create_belief?
      user_belief = UserBelief.new(belief: belief, user: current_user, conviction: params[:conviction])
      if user_belief.save!
        create_connections_for(belief)
        redirect 'pagethatdoesntexist'
      end
    end
    redirect_to root_path
  end

  def create_belief?
    params[:conviction].to_i > 5
  end
end

