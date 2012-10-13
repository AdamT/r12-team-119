class GroupsController < ApplicationController
  before_filter :authorize_user!, except: :show
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
    g = Group.find_by_slug(params[:id])

    if g
      if current_user.id == g.user_id && g.destroy
        redirect_to dashboard_path, notice: "Removed"
      else
        redirect_to dashboard_path, error: "Couldn't delete the group (you probably didn't create it)"
      end
    else
      redirect_to dashboard_path, error: "Couldn't find that."
    end
  end

  def update
  end
end
