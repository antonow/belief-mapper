module ApplicationHelper
  def current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end

  def create_connections_for(belief)
    # insert code here from seeds
  end
end
