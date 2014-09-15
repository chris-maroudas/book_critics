class AddReviewsCountToBooks < ActiveRecord::Migration
  def change
    add_column :books, :reviews_count, :integer
  end
end
