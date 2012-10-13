class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper
  def authorize_user!
    unless logged_in?
      redirect_to login_path
    else
      true
    end
  end
end
