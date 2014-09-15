class AddApprovedReviewsCountToBooks < ActiveRecord::Migration
  def change
    add_column :books, :approved_reviews_count, :integer
  end
end
