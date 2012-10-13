class GroupsController < ApplicationController
  before_filter :authorize_user!, except: :show
  before_filter :finding_group, except: [:index, :create]
  def index
    @group_list = current_user.groups
    @own_group_list = current_user.own_groups
    @group_list.reject!{|g| g.title.blank?  }
    @own_group_list.reject!{|g| g.title.blank?  }
  end

  def show
  end

  def edit
  end

  def create
    g = Group.create(:user_id => current_user.id)
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
  end

  def finding_group
    @group = Group.find_by_slug(params[:id])

    unless @group
      redirect_to dashboard_path, error: "Couldn't find that."
    end

  end
end
