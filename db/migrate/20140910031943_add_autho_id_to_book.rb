class AddAuthoIdToBook < ActiveRecord::Migration
  def change
    add_column :books, :author_id, :integer
  end
end
