class SessionsController < ApplicationController
  layout 'simple'
  def login
    if params[:token] && user = User.confirm_login(params[:token])
      set_token_for(user)
      redirect_to root_path
    elsif logged_in?
      redirect_to root_path
    else
      group_waiting = nil
      group_waiting = Group.find(session[:group_waiting]) if session[:group_waiting]
      flash.now[:notice] = "That token seems to have expired" if params[:token]
      flash.now[:notice] = "We'll need to confirm your email to save your changes" if session[:participant_waiting]
      flash.now[:notice] = "One last thing... we'll need you to log in you'll want to make changes (<a href='#{group_path(group_waiting)}'>skip</a>)".html_safe if group_waiting
      render :login
    end
  end

  def check_email
    if user = User.find_by_email(params[:email])
      render :json => {}
    else
      render :json => {}, :status => :not_found
    end
  end

  def logout
    set_token_for(nil)
    redirect_to root_path, notice: 'You have been logged out'
  end

  def register
    if user = User.find_by_email(params[:user][:email])
      handle_waiting_for(user)
      Notifications.login(user).deliver
      redirect_to waiting_path
    else
      user = User.new(params[:user])
      if user.save
        handle_waiting_for(user)
        Notifications.confirm(user).deliver
        redirect_to confirming_path, notice: "Confirmation email sent."
      else
        redirect_to login_path, error: "Looks like something went wrong. Sorry about that!"
      end
    end
  end

  def confirm
  end
  def waiting
  end

  def handle_waiting_for(user)
    if session[:group_waiting]
      group = Group.find(session[:group_waiting])
      group.user_id = user.id
      group.save
      session[:group_waiting] = nil
    elsif session[:participant_waiting]
      time = GroupParticipant.find(session[:participant_waiting])
      time.user_id = user.id
      time.save
      session[:participant_waiting] = nil

    end
  end

end
