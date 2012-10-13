module SessionsHelper
  def logged_in?
    !current_user.nil?
  end

  def current_user
    return nil unless current_token
    @current_user = User.find_by_token(current_token)
  end
  def current_token
    cookies[:user_token] || session[:user_token]
  end
  def set_token_for(user = nil)
    if user.nil?
      session[:user_token] = nil
      cookies.delete :user_token
    else
      session[:user_token] = user.token
      cookies[:user_token] = {value: user.token, expires: 1.year.from_now}
    end
  end
end
