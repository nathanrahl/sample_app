class UsersController < ApplicationController

  before_filter :signed_in_user,
                 only: [:index,:edit,:update,:destroy,:following,:followers]
  before_filter :correct_user, only: [:edit,:update]
  before_filter :admin_user, only: :destroy
  before_filter :confirmed_user,
                 only: [:index,:edit,:update,:destroy,:following,:followers]
  
  def show
    @user = User.find(params[:id])
    if current_user?(@user)
      @microposts = @user.microposts.paginate(page: params[:page])
    else
      @microposts = @user.microposts.no_replies.paginate(page: params[:page])
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.registration_confirmation(@user).deliver
      flash[:success] = "Account successfully created. Please confirm your
                          account by clicking on the confirmation link sent
                          at the email address you provided."
      redirect_to root_url 
    else
      render 'new'
    end
  end

  def edit
  end    

  def index
    @users=User.paginate(page: params[:page])
  end

  def update
    @reconfirm = @user.email != params[:user][:email]
    @user.attributes=(params[:user])

    if @user.valid?
      if @reconfirm
        @user.update_attribute(:confirmed_at, nil)
        UserMailer.registration_confirmation(@user).deliver
        flash[:success] = "Please confirm your new email address by clicking on the confirmation link sent
                          at the email address you provided."
        sign_out
        redirect_to root_url 
      else
        @user.update_attributes(params[:user])
        flash[:success] = "Profile updated"
        sign_in @user
        redirect_to @user
      end
    else
      render 'edit'
    end
  end    
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def confirm
    @user = User.find(params[:id])
    if @user.confirmation_token == params[:confirmation_token]
      @user.update_column(:confirmed_at, Time.now)
      flash[:success] = "Your email address has been confirmed. Welcome to the Sample App!"
      sign_in @user
      redirect_to @user
    else
      flash[:notice] = "Invalid confirmation code"
      redirect_to root_url
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
