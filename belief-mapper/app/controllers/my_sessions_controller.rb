class MySessionsController < ApplicationController
  def destroy
    session.clear
    redirect_to root_path
  end

  # def create

  #   # raise current_user
  #   # session[:user_id] = @user.id
  #   redirect_to beliefs_path
  # end

end
