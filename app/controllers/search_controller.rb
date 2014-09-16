class SearchController < ApplicationController

  def search
    if params[:q].nil?
      @books = []
    else
      @books = Book.search(params[:q]).records
    end
  end

end
