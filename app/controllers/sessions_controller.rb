class SessionsController < ApplicationController
 
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.confirmed_at 
        sign_in user, params[:remember_me]
        redirect_back_or user
      else
        flash.now[:notice] = 'Please confirm your email address.'
        render 'new'
      end
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
	
end
