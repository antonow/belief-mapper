class WelcomeController < ApplicationController
  skip_before_filter :require_login

  def about
    
  end

  def index

    unless user_signed_in?
#       @demograph = true
#       @jsondata = {
#           "beliefs" => [
# {
# "id"=> 1,
# "name"=> "Belief",
# "definition"=> "Belief description",
# "count"=> 15,
# "hsl"=> 100
# },
# {
# "id"=> 2,
# "name"=> "Belief",
# "definition"=> "Belief description",
# "count"=> 20,
# "hsl"=> 50
# },
# {
# "id"=> 3,
# "name"=> "Belief",
# "definition"=> "Belief description",
# "count"=> 10,
# "hsl"=> 10
# }
# ],

# "connections"=> [
# {
# "source"=> 1,
# "target"=> 2,
# "value"=> 5
# },
# {
# "source"=> 2,
# "target"=> 3,
# "value"=> 8
# }
# ]}
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
