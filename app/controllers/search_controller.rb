class SearchController < ApplicationController

  def search
    if params[:q].nil?
      @books = []
    else
      # .records.pluck(:book_id) could be used, but ordering is lost.
      results = SearchData.search(params[:q]).map(&:book_id)
      @books = []
      results.each do |book_id|
        @books << Book.find(book_id)
      end
    end
  end

end
