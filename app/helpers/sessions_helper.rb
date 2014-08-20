module SessionsHelper

  # Signs in the user by assigning them their remember_token as a cookie
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  # Returns whether or not a user is signed in
  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  # Setter for current session's user
  def current_user=(user)
    @current_user = user
  end

  # Getter for current session's user
  # TODO: Refactor this logic into User model
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  # Filter for requests that require a logged in user
  def user_signed_in
    unless signed_in?
      store_address
      redirect_to signin_path, notice: "Please sign in"
    end
  end

  # Filter for requests that require user be an admin
  def user_is_admin
    redirect_to root_path unless current_user && current_user.is_admin
  end

  # Friendly forwarding
  def store_address
    session[:return_to] = request.fullpath
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
end
