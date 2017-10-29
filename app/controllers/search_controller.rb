class SearchController < ApplicationController
  def index
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

    like1 = Like.find_by(from_id: @myid, to_id: @user.id)
    like2 = Like.find_by(from_id: @user.id, to_id: @myid)

    if like1 != nil && like2 != nil
      chat = Chat.new(male_id: @myid, female_id: @user.id)
      chat.save
    end

    redirect_to "/search/users/#{@user.id}"


  end

  private
end
