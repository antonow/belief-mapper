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
            max = Belief.where("user_count > ?", show_greater_than).count
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
        @beliefs = Belief.order('user_count DESC')
        @category = nil
        @count = 30
        if params[:count].present?
          @count = params[:count].to_i unless params[:count].to_i <= 0
          @beliefs = @beliefs.limit(@count).where("user_count > ?", show_greater_than)
        end

        selected_category = params[:category]
        if selected_category.present? && !["All", "Category"].include?(selected_category)
          @beliefs = @beliefs.where(category_id: selected_category).where("user_count > ?", show_greater_than)
        end

        belief_ids = @beliefs.map { |belief| belief.id }

        @connections = Connection.where(:belief_1_id => belief_ids, :belief_2_id => belief_ids)
        render { render :json => {:beliefs => @beliefs,
                                  :connections => @connections }}
      }
      format.all {
        sign_out(current_user)
        redirect_to new_user_session_path
      }
    end
  end


  def user
    b = current_user.beliefs
    @beliefs = []
    b.each {|bel| @beliefs << bel}
    @connections = []
    user_belief_ids = b.pluck(:id)
    # @beliefs.each do |belief|
    @connections = Connection.where(:belief_1_id => user_belief_ids, :belief_2_id => user_belief_ids)
    @connections = @connections.to_a.compact
    # @connections.uniq
    @beliefs
  end

  def filter
  @beliefs = Belief.all
  @connections = Connection.all
  end

  def results
    raise 'here'
  end

  def show
    @belief = Belief.find(params[:id])
  end

  def search
    @results = Belief.search(params[:query])
    @query = params[:query]
    render "results"
  end

  def autocomplete
    render json: Belief.search(params[:query], fields: [{name: :text_start}], limit: 10).map(&:name)
  end

  def list
    @results = Belief.all.order(name: :asc)
    render "list"
  end



  def filter_params
    params.require(:filter).permit(:gender, :religion, :education_level)
  end

end