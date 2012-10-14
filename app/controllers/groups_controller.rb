class GroupsController < ApplicationController
  before_filter :authorize_user!, only: [:index, :destroy]
  before_filter :finding_group, except: [:index, :create]
  def index
    @group_list = current_user.groups
    @own_group_list = current_user.own_groups
    @group_list.select!{|g| g.ready? && !g.owned_by?(current_user)  }
    @own_group_list.select!{|g| g.ready?  }
  end

  def show
    if logged_in?
      unless @me = current_user.responses.detect{|r| r.group_id == @group.id}
        @me = GroupParticipant.new(group: @group_id)
      end
      @timecard = @me.timecard
    else
      @timecard = Timecard.new
    end
  end

  def edit
    if logged_in?
      if current_user.id != @group.user_id
        redirect_to group_path(@group)
      else
      end
    else
    end
  end

  def set_user
    if logged_in?
      unless @me = current_user.responses.detect{|r| r.group_id == @group.id}
        @me = GroupParticipant.new(group_id: @group_id)
      end
      @me.fill_timecard_with(params[:slots])
      current_user.responses << @me
      @group.group_participants << @me
      current_user.save
      @group.save
      @me.save
      redirect_to group_path(@group), notice: "Saved Changes"
    else
      @me = GroupParticipant.new(group_id: @group_id)
      @me.fill_timecard_with(params[:slots])
      @group.group_participants << @me
      @group.save
      @me.save
      session[:participant_waiting] = @me.id
      redirect_to login_path
    end
  end

  def create
    if logged_in?
      g = Group.create(:user_id => current_user.id)
    else
      g = Group.create()
      session[:group_waiting] = g.id
    end
    if g
      redirect_to edit_group_path(g)
    else
      redirect_to dashboard_path, error: "Couldn't create the group for some reason"
    end
  end

  def destroy
    if current_user.id == @group.user_id && @group.destroy
      redirect_to dashboard_path, notice: "Removed"
    else
      redirect_to dashboard_path, error: "Couldn't delete the group (you probably didn't create it)"
    end
  end

  def update
    if logged_in?
      if current_user.id != @group.user_id
        redirect_to group_path(@group)
      else
        @group.update_attributes(params[:group])
        @group.fill_timecard_with(params[:slots])
        @group.group_participants.each do |p|
          p.mask_timecard_with(@group.timecard)
          p.save
        end
        @group.save
        redirect_to group_path(@group), notice: "Saved Changes"
      end
    else
      if @group.user_id.nil?
        @group.update_attributes(params[:group])
        @group.fill_timecard_with(params[:slots])
        @group.save
        redirect_to login_path
      else
        redirect_to group_path(@group)
      end
    end
  end

  def finding_group
    @group = Group.find_by_slug(params[:id])

    unless @group
      redirect_to dashboard_path, error: "Couldn't find that."
    end

  end
end
