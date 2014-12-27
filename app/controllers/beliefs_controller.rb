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
            @count = 30
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
        @beliefs = Belief.order('user_count DESC').where('avg_conviction > ?', 60)
        @category = nil
        @count = 30
        if params[:count].present?
          @count = params[:count].to_i unless params[:count].to_i <= 0
          @beliefs = @beliefs.limit(@count)
        end

        selected_category = params[:category]
        if selected_category.present? && !["All", "Category"].include?(selected_category)
          @beliefs = @beliefs.where(category_id: selected_category)
        end

        @connections = []
        @divide_by = 1
        @c_divide_by = 1

        unless @beliefs.count <= 1
          min_max = @beliefs.map { |belief| belief.user_count }.minmax
          min = min_max[0]
          range = min_max[1] - min
          if range >= MAX_BELIEF_SIZE_RANGE
            @divide_by = range / MAX_BELIEF_SIZE_RANGE
          end

          belief_ids = @beliefs.pluck(:id)

          @connections = Connection.where(:belief_1_id => belief_ids, :belief_2_id => belief_ids).where("strong_connections >= ?", MIN_CONN_COUNT)

          unless @connections.count <= 1
            c_min_max = @connections.map { |conn| conn.strong_connections }.minmax
            c_min = c_min_max[0]
            c_range = c_min_max[1] - c_min
            @c_divide_by = 1
            if c_range > 5
              @c_divide_by = c_range / 5
            end
          end
        end

        render { render :json => {:beliefs => @beliefs,
                                  :connections => @connections,
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
    @belief = Belief.find(params[:id])
    @comment = Comment.new
    @comments = Comment.tagged_with(@belief.name)
  end

  def autocomplete
    render json: Belief.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
  end

  def list
    @results = Belief.all.order(user_count: :desc)
    render "list"
  end



  def filter_params
    params.require(:filter).permit(:gender, :religion, :education_level)
  end

end
