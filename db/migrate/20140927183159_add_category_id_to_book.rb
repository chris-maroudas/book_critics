class AddCategoryIdToBook < ActiveRecord::Migration
  def change
    add_reference :books, :category, index: true
  end
end
