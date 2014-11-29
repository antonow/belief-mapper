module ApplicationHelper
  # Returns current user if it exists
  def current_user
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end

  # Returns true or false for whether there is a current user
  def current_user?
    if session[:user_id]
      true
    else
      false
    end
  end

  def create_connections_for(belief)
    # insert code here from seeds
  end
end
