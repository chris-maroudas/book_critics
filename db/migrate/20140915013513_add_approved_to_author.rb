class AddApprovedToAuthor < ActiveRecord::Migration
  def change
    add_column :authors, :approved, :boolean, default: false
  end
end
