class WelcomeController < ApplicationController

  def index
    if current_user == nil
      @belief = Belief.all.sample
    else
      @belief = current_user.unexamined_beliefs.sample
    end
  end
end
