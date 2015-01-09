class BeliefsController < ApplicationController
  def index
    show_greater_than = 0

    respond_to do |format|
      format.html {
        unless user_signed_in?
          redirect_to '/'
        else
          if params[:query].present?
            @results = Belief.search(params[:query])
          else
            max = Belief.count
            if params[:category].present?
              selected_category = params[:category]
              unless ["All", "Category"].include?(selected_category)
                @category = Category.find(selected_category.to_i)
                max = @category.total_beliefs
              end
            end
            @count = DEFAULT_MAX_BELIEFS
            if params[:count].present?
              @count = params[:count].to_i unless params[:count].to_i <= 0
              if @count >= max
                @maxed_out = max
              end
            end
          end
        end
      }
      format.json {
        @beliefs = Belief.order('user_count DESC').where('avg_conviction > ?', 5)
        @category = nil
        @count = DEFAULT_MAX_BELIEFS

        selected_category = params[:category]
        if selected_category.present? && !["All", "Category"].include?(selected_category)
          @beliefs = @beliefs.where(category_id: selected_category)
        end

        if params[:count].present?
          @count = params[:count].to_i unless params[:count].to_i <= 0
        end
        @beliefs = @beliefs.limit(@count)

        @connections = []
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
      format.all {
        sign_out(current_user)
        redirect_to new_user_session_path
      }
    end
  end

  def filter
  @beliefs = Belief.all
  @connections = Connection.all
  end

  def search
    @results = Belief.search(params[:query])
    @query = params[:query]
    render "results"
  end

  def show
    @belief = Belief.friendly.find(params[:id])
    @comment = Comment.new
    @comments = Comment.where(comment_id: nil).tagged_with(@belief.name).reverse
  end

  def autocomplete
    render json: Belief.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
  end

  def beliefs
    redirect_to belief_path(params[:id])
  end

  def list
    @results = Belief.all.order(user_count: :desc)
    render "list"
  end

  def filter_params
    params.require(:filter).permit(:gender, :religion, :education_level)
  end

end
