class WelcomeController < ApplicationController

  def index
    if current_user == nil
      @belief = Belief.all.where(starred: true).sample
    else
      redirect_to users_path
      # unless starred.empty?
      #   @belief = unexamined_for_user.sample
      # else
      #   @belief = current_user.unexamined_beliefs.sample
      # end
    end
  end
end
