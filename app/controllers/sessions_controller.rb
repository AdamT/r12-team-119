class SessionsController < ApplicationController
  def login
    if params[:token] && user = User.confirm_login(params[:token])
      set_token_for(user)
      redirect_to root_path
    elsif logged_in?
      redirect_to root_path
    else
      flash.now[:notice] = "That token seems to have expired" if params[:token]
      render :login
    end
  end

  def logout
    set_token_for(nil)
    redirect_to root_path, notice: 'You have been logged out'
  end

  def register
    if user = User.find_by_email(params[:user][:email])
      Notifications.login(user).deliver
      redirect_to root_path, notice: "Please check your email for a login token."
    else
      params[:user][:name] = "Random Person" unless params[:user][:name]
      user = User.new(params[:user])
      if user.save
        Notifications.confirm(user).deliver
        redirect_to confirming_path, notice: "Confirmation email sent"
      else
        redirect_to login_path, error: "Looks like something went wrong. Sorry about that!"
      end
    end
  end

  def confirm
  end

end
