class WelcomeController < ApplicationController

  def index
    if current_user == nil
      @belief = Belief.all.where(starred: true).sample
    else
      starred = current_user.unexamined_beliefs.where(starred: true)
      unless starred.empty?
        @belief = unexamined_for_user.sample
      else
        @belief = current_user.unexamined_beliefs.sample
      end
    end
    raise @belief.name
  end
end
