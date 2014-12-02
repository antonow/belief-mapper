class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
# skip_before_filter  :verify_authenticity_token

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    # raise "we're here"
    # @user = User.new(email: )
    # super
    @user = User.new(
      email: params[:resource][:email],
      password: params[:resource][:password],
      password_confirmation: params[:resource][:password_confirmation]
      )

    if params[:resource][:password] != params[:resource][:password_confirmation]
      flash[:error] = "Passwords do not match."
      render :'devise/registrations/new' #:template => :back # "registrations_contr/index

    elsif @user.save
      session[:user_id] = @user.id
      flash[:success] = "User created!"
      sign_in @user, :bypass => true
      redirect_to beliefs_path

    else
      flash[:error] = "We could not create an account for you."
      render :'devise/registrations/new'#:template => :back # "registrations_contr/index"
    end

    Demographic.create!(
      user: @user,
      gender: params[:demographic][:gender],
      age: params[:demographic][:age],
      religion: params[:demographic][:religion],
      country: params[:demographic][:country],
      state: params[:demographic][:state],
      education_level: params[:demographic][:education_level]
      )

    # @user.save
    # sign_in @user
    # sign_in @user, :bypass => true
    # redirect_to beliefs_path
  end

  # def after_sign_up_path_for(user)
  #    beliefs_path
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
