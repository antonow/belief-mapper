class WelcomeController < ApplicationController

  def index
    if current_user
    @belief = Belief.all.sample
  end
end
