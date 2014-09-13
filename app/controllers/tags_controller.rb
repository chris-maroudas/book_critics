class TagsController < ApplicationController
  def show
    @books = params[:id].blank? ? nil : Book.tagged_with(params[:id])
    render 'books/index'
  end

  def index
    @tags = ActsAsTaggableOn::Tag.all
  end
end
