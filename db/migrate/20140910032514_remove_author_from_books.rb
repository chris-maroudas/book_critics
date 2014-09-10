class RemoveAuthorFromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :author
  end
end
