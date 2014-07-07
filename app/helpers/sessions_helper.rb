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
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
end
