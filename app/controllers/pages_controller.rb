class PagesController < ApplicationController
  def home
    @on_splash = "splash"

    if request.path == '/' && logged_in?
      redirect_to dashboard_path
    else
    end
  end
end
