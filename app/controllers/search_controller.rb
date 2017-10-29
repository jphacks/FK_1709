class SearchController < ApplicationController
  def index
    @users = User.where(id: current_user.friend_ids)
  end

  def show
    @user = User.find(params[:id])

    if params[:like].to_i == 1
      like = Like.new(from_id: @myid, to_id: @user.id)
      like.save
    end

    @myid = current_user.id

    @like = Like.find_by(from_id: @myid, to_id: @user.id)

    if @like == nil
      @image_path = 'like/LikeButton.svg'
    else
      @image_path = 'like/LikedButton.svg'
    end

  end

  private
end
