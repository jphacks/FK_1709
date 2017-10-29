class SearchController < ApplicationController
  def index

    @users = User.where(id: current_user.friend_ids)
  end

  def show
    @user = User.find(params[:id])
  end

  private
end
