class AddBooksCountToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :books_count, :integer
  end
end
