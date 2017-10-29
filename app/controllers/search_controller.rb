class SearchController < ApplicationController
  def index
    @users = User.where(id: current_user.friend_ids)
  end

  def show
    @user = User.find(params[:id])
    @myid = current_user.id

    @like = Like.find_by(from_id: @myid, to_id: @user.id)

    if @like == nil
      @image_path = 'like/LikeButton.svg'
    else
      @image_path = 'like/LikedButton.svg'
    end

  end

  def like
    @user = User.find(params[:id])
    @myid = current_user.id

    @like = Like.new(from_id: @myid, to_id: @user.id)
    @like.save

    @like = Like.find_by(from_id: @myid, to_id: @user.id)

    redirect_to "/search/users/#{@user.id}"
  end

  private
end
