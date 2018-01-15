class SessionsController < ApplicationController
  def new
    if logged_in?
      flash[:success] = "You are already logged in!"
      redirect_to @current_user
    end
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
      if user.activated?
    		log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    		flash[:success] = "Welcome back!"
    		redirect_back_or(user)
      else
        flash[:danger] = "The account is not activated yet! Please check your email!"
        redirect_to root_url
      end
  	else
  		flash.now[:danger] = "Please enter valid email and password"
  		render 'new'
  	end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
