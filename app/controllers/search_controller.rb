class SearchController < ApplicationController
  def index
  end

  def show
    @user = User.find(params[:id])
  end

  private
end
