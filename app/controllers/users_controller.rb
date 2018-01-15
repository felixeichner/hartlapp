class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page], per_page: 15)
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      @user.send_activation_email
      flash[:success] = "Please check your email to activate your account!"
  		redirect_to root_url
  	else
  		render 'new'
  	end
  end

  def show
  	@user = User.find(params[:id])
    unless @user.activated?
      flash[:danger] = "User is not yet verified!"
      redirect_back_or root_url
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile details updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      @user.destroy
      flash[:success] = "Your profile has been successfully deleted!"
      redirect_to root_path
    else
      @user.destroy
      flash[:success] = "Profile successfully deleted!"
      redirect_to users_path
    end
  end

  private

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "You need to be logged in!"
        redirect_to login_path
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "You are not authorized for this action!"
        redirect_to root_url
      end
    end

    def admin_user
      unless current_user.admin? || current_user?(User.find(params[:id]))
        flash[:danger] = "You can only delete your own profile!"
        redirect_to current_user
      end
    end

	  def user_params
	  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end
end
