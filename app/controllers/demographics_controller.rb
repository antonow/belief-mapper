class DemographicsController < ApplicationController
  def new
    unless user_signed_in?
      redirect_to '/'
    end
  end

  def create
    demographic = Demographic.new(demographic_params)
    demographic.user = current_user
    if demographic.save
      redirect_to '/beliefs'
    else
      redirect_to :back
    end
  end

  def edit
    @demographic = current_user.demographic
  end

  def update
    if current_user.demographic.update(demographic_params)
      redirect_to '/beliefs'
    else
      render :back
    end
  end

  private
  def demographic_params
    params.require(:demographic).permit(:gender, :age, :religion, :country, :state, :education_level)
  end
end
