class UsersController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        @beliefs = current_user.held_beliefs_by_conviction
        @connections = []
  
        min_max = @beliefs.map { |belief| belief.user_count }.minmax
        min = min_max[0]
        range = min_max[1] - min
        @divide_by = 1
        if range > 8
          @divide_by = range / 8
        end

        belief_ids = @beliefs.map { |belief| belief.id }

        @connections = Connection.where(:belief_1_id => belief_ids, :belief_2_id => belief_ids).where("strong_connections > ?", 0)

        render { render :json => {:beliefs => @beliefs,
                                  :connections => @connections,
                                  :min => @min,
                                  :divide_by => @divide_by }}
      }
      format.html {
        unless user_signed_in?
          redirect_to '/'
        end
      }
    end
  end

  def your_beliefs
    @results = current_user.user_beliefs.order('conviction DESC')
  end

  def skip
      render :partial => "/beliefs/main_topbar"
  end

  def show
    respond_to do |format|
      format.json {
        @user = User.find_by(unique_url: params[:id])
        @beliefs = @user.held_beliefs

        min_max = @beliefs.map { |belief| belief.user_count }.minmax
        min = min_max[0]
        range = min_max[1] - min
        @divide_by = 1
        if range > 8
          @divide_by = range / 8
        end

        belief_ids = @beliefs.pluck(:id)

        @connections = Connection.where(:belief_1_id => belief_ids, :belief_2_id => belief_ids).where("strong_connections > ?", 0)

        render { render :json => {:beliefs => @beliefs,
                                  :connections => @connections,
                                  :min => @min,
                                  :divide_by => @divide_by }}
      }
      format.html {}
    end
  end

end
