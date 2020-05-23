module SessionsHelper
  #logs user in
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user == current_user
  end

#returns the current logged in user
  def current_user
    if(user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) #elsif not elseif
      #raise
      user = User.find_by(id: user_id)
      if  user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location or default
  def redirect_back_or(default)
    redirect_to(session[:forward_url] || default)
    session.delete(:forwarding_url)
  end

  #stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
