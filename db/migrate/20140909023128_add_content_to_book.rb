class AddContentToBook < ActiveRecord::Migration
  def change
    add_column :books, :content, :text
  end
end
