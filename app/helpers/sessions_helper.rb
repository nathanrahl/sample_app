module SessionsHelper
  def sign_in(user,permanent)
    if permanent 
      cookies.permanent[:remember_token] = user.remember_token
    else
      cookies[:remember_token] = user.remember_token
    end
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def confirmed?
    !current_user.nil? && ( current_user.confirmed_at != nil )
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user==current_user
  end

  def signed_in_user 
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def confirmed_user 
    unless confirmed?
      redirect_to root_url, notice: "Please confirm your email address."
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  
  def store_location
    session[:return_to] = request.url
  end
end
