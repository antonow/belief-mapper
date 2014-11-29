class UserBeliefsController < ApplicationController
  def create
    belief = Belief.find(params[:belief])
    # @count = 0
    user_belief = UserBelief.new(belief: belief, user: current_user, conviction: params[:conviction])
    if user_belief.save!
      create_connections_for(belief)
      # if @count = user.beliefs.count >= 3
      redirect 'pagethatdoesntexist'
      # end
    end
    render 'welcome/index'
  end

  # def create_belief?
  #   params[:conviction].to_i > 5
  # end
end

