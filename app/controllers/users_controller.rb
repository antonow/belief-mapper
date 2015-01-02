class UsersController < ApplicationController
  skip_before_filter :require_login, :only=>[:show, :skip, :refresh_question, :show]

  def index
    respond_to do |format|
      format.json {
        @connections = []
        @beliefs = current_user.held_beliefs_by_conviction
        count = @beliefs.count

        @divide_by = 1
        @subtract = 0

        if count > 1
          min_max = @beliefs.map { |belief| belief.user_count }.minmax
          min = min_max[0]
          max = min_max[1]
          range = max - min
          if range >= MAX_BELIEF_SIZE_RANGE
            @divide_by = range / MAX_BELIEF_SIZE_RANGE
          end
          @divide_by = 1 if @divide_by <= 0
          @subtract = max / @divide_by - MAX_BELIEF_SIZE
        elsif count == 1
          @subtract = @beliefs.first.user_count - MAX_BELIEF_SIZE
        end

        @subtract = 0 if @subtract < 0
          
        belief_ids = @beliefs.map { |belief| belief.id }

        @connections = Connection.where(:belief_1_id => belief_ids,
                                        :belief_2_id => belief_ids
                                        ).order('strong_connections DESC').limit(count * CONN_MULTIPLIER)
        # where("strong_connections >= ?", MIN_CONN_COUNT)

        @c_divide_by = 1
        @c_subtract = 0

        if @connections.count > 1
          c_min_max = @connections.map { |conn| conn.strong_connections }.minmax
          c_min = c_min_max[0]
          c_max = c_min_max[1]
          c_range = c_max - c_min
          if c_range >= MAX_CONN_SIZE_RANGE
            @c_divide_by = c_range / MAX_CONN_SIZE_RANGE
          end
          @c_divide_by = 1 if @c_divide_by <= 0
          @c_subtract = (c_max / @c_divide_by) - MAX_CONN_SIZE
        elsif @connections.count == 1
          @c_subtract = @connections.first.strong_connections - MAX_CONN_SIZE
        end

        @c_subtract = 0 if @c_subtract < 0

        render { render :json => {:beliefs => @beliefs,
                                  :connections => @connections,
                                  :subtract => @subtract,
                                  :c_subtract => @c_subtract,
                                  :divide_by => @divide_by,
                                  :c_divide_by => @c_divide_by }}
      }
      format.html {
        
          @total_user_beliefs = current_user.held_beliefs.count
    
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
    if params[:sliderOnly]
      @belief = Belief.find(params[:id].to_i)
      render partial: "beliefs/slider_form", locals: { belief: @belief }
    else
      render :partial => "/beliefs/main_topbar"
    end
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
        @connections = []
        @beliefs = current_user.held_beliefs_by_conviction
        count = @beliefs.count

        @divide_by = 1
        @subtract = 0

        if count > 1
          min_max = @beliefs.map { |belief| belief.user_count }.minmax
          min = min_max[0]
          max = min_max[1]
          range = max - min
          if range >= MAX_BELIEF_SIZE_RANGE
            @divide_by = range / MAX_BELIEF_SIZE_RANGE
          end
          @divide_by = 1 if @divide_by <= 0
          @subtract = max / @divide_by - MAX_BELIEF_SIZE
        elsif count == 1
          @subtract = @beliefs.first.user_count - MAX_BELIEF_SIZE
        end

        @subtract = 0 if @subtract < 0
          
        belief_ids = @beliefs.map { |belief| belief.id }

        @connections = Connection.where(:belief_1_id => belief_ids,
                                        :belief_2_id => belief_ids
                                        ).order('strong_connections DESC').limit(count * CONN_MULTIPLIER)
        # where("strong_connections >= ?", MIN_CONN_COUNT)

        @c_divide_by = 1
        @c_subtract = 0

        if @connections.count > 1
          c_min_max = @connections.map { |conn| conn.strong_connections }.minmax
          c_min = c_min_max[0]
          c_max = c_min_max[1]
          c_range = c_max - c_min
          if c_range >= MAX_CONN_SIZE_RANGE
            @c_divide_by = c_range / MAX_CONN_SIZE_RANGE
          end
          @c_divide_by = 1 if @c_divide_by <= 0
          @c_subtract = (c_max / @c_divide_by) - MAX_CONN_SIZE
        elsif @connections.count == 1
          @c_subtract = @connections.first.strong_connections - MAX_CONN_SIZE
        end

        @c_subtract = 0 if @c_subtract < 0

        render { render :json => {:beliefs => @beliefs,
                                  :connections => @connections,
                                  :subtract => @subtract,
                                  :c_subtract => @c_subtract,
                                  :divide_by => @divide_by,
                                  :c_divide_by => @c_divide_by }}
      }
      format.html {
        redirect_to root_path if User.find_by(unique_url: params[:id]).nil?
      }
    end
  end

end
