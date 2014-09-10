class AddSearchableTermsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :searchable_terms, :string
  end
end
