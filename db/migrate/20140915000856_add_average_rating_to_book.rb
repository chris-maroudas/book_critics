class AddAverageRatingToBook < ActiveRecord::Migration
  def change
    add_column :books, :average_rating, :float
  end
end
