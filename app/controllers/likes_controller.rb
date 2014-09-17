class LikesController < ApplicationController

  before_filter :check_if_user_is_logged

  def index
  end

  def create
    @like = current_user.likes.new(like_params)
    @book = @like.book
    respond_to do |format|
      if @like.save
        format.html { redirect_to @like.book, notice: "Liked!" }
        format.js { }
      else
        redirect_to @like.book, notice: "An error occured!"
      end
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @book = @like.book

    respond_to do |format|
      if @like.destroy
        format.html { redirect_to @like.book, notice: "Unloved!" }
        format.js {  }
      else
        format.html { redirect_to @like.book, notice: "An error occured!" }
        format.js { }
      end
    end

  end

  private

    def check_if_user_is_logged
      redirect_to root_url, notice: "You must be logged in to do that!" unless user_signed_in?
    end

    def like_params
      params.require(:like).permit(:book_id)
    end

end
