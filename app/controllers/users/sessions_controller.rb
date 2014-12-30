class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  skip_before_filter :require_login
  
  # GET /resource/sign_in
  def new
    # sign_out(current_user)
    super
  end

  # POST /resource/sign_in
  def create
    super
    puts "==================="
    puts current_user
  end

  def after_sign_in_path_for(resource)
    beliefs_path #your path
  end

  # DELETE /resource/sign_out
  # def destroy
  #   session[:user_id].delete
  #   # super
  # end


  # def delete
  #   super
  # end


  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
