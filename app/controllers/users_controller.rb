class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
    @projects = @user.projects.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
    #@user.activated = true
  	if @user.save
      log_in @user
      #UserMailer.account_activation(@user).deliver_now
      #flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
  	else
  	  render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    followed_following("following", params[:id], params[:page])
  end

  def followers
    followed_following("followers", params[:id], params[:page])
  end

  private

    def followed_following(decision, id, page)
      @user = User.find(id)
      if decision == "followers"
        @users = @user.followers.paginate(page: page)
      else
        @users = @user.following.paginate(page: page)
      end
      render 'show_follow'
    end

    def user_params
  	  params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    # Confirms a logged in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url 
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirma an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
