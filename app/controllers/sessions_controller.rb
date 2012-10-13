class SessionsController < ApplicationController
  def login
    if params[:token] && user = User.find_by_token(params[:token])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Welcome back, #{user.name}!"
    else
      render :login
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path, notice: 'You have been logged out'
  end

  def register
    if user = User.find_by_email(params[:user][:email])
      # TODO: Already exists, send token to email
      Notifications.login(user).deliver!
      redirect_to root_path, notice: "Please check your email for a login token."
    else
      user = User.new(params[:user])
      if user.save
        raise user.inspect
      else
        raise "failed"
      end
    end
  end

end
