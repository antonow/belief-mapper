class UsersController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        @beliefs = current_user.held_beliefs_by_conviction
        @connections = []

        unless @beliefs.count <= 1
          min_max = @beliefs.map { |belief| belief.user_count }.minmax
          min = min_max[0]
          range = min_max[1] - min
          @divide_by = 1
          if range >= MAX_BELIEF_SIZE_RANGE
            @divide_by = range / MAX_BELIEF_SIZE_RANGE
          end
          
          belief_ids = @beliefs.map { |belief| belief.id }

          @connections = Connection.where(:belief_1_id => belief_ids,
                                          :belief_2_id => belief_ids
                                          ).where("strong_connections >= ?", MIN_CONN_COUNT)

          unless @connections.count <= 1
            c_min_max = @connections.map { |conn| conn.strong_connections }.minmax
            c_min = c_min_max[0]
            c_range = c_min_max[1] - c_min
            @c_divide_by = 1
            if c_range > 5
              @c_divide_by = c_range / 5
            end
          else
            @c_divide_by = 1
          end
        else
          @divide_by = 1
          @c_divide_by = 1
        end

        render { render :json => {:beliefs => @beliefs,
                                  :connections => @connections,
                                  :divide_by => @divide_by,
                                  :c_divide_by => @c_divide_by }}
      }
      format.html {
        unless user_signed_in?
          redirect_to '/'
        else
          @total_user_beliefs = current_user.held_beliefs.count
        end
      }
    end
  end

  def your_beliefs
    all_beliefs = current_user.user_beliefs
    @answered = all_beliefs.where(skipped: false).order('conviction DESC')
    @results = all_beliefs.where(skipped: true).map { |user_belief| user_belief.belief }
  end

  def refresh_question
    # current_user.increment_questions_answered 
    render :partial => "/beliefs/main_topbar"
  end

  def skip
    if params["id"] == "other"
      current_user.increment_questions_answered
    else
      belief = Belief.find(params["id"].to_i)
      UserBelief.create(user: current_user, belief: belief, skipped: true)
      # user.skipped_belief_ids << user_belief.belief_id
    end
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def show
    respond_to do |format|
      format.json {
        @user = User.find_by(unique_url: params[:id])
        @beliefs = @user.held_beliefs_by_conviction

        min_max = @beliefs.map { |belief| belief.user_count }.minmax
        min = min_max[0]
        range = min_max[1] - min
        @divide_by = 1
        if range >= MAX_BELIEF_SIZE_RANGE
          @divide_by = range / MAX_BELIEF_SIZE_RANGE
        end

        belief_ids = @beliefs.map { |belief| belief.id }

        @connections = Connection.where(:belief_1_id => belief_ids,
                                        :belief_2_id => belief_ids
                                        ).where("strong_connections >= ?", MIN_CONN_COUNT)

        c_min_max = @connections.map { |conn| conn.strong_connections }.minmax
        c_min = c_min_max[0]
        c_range = c_min_max[1] - c_min
        @c_divide_by = 1
        if c_range > 5
          @c_divide_by = c_range / 5
        end

        render { render :json => {:beliefs => @beliefs,
                                  :connections => @connections,
                                  :divide_by => @divide_by,
                                  :c_divide_by => @c_divide_by }}
      }
      format.html {}
    end
  end

end
