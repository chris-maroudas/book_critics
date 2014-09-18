class CreateSearchData < ActiveRecord::Migration
  def change
    create_table :search_data do |t|
      t.references :book
      t.string :title
      t.string :author_name
      t.string :tags
      t.timestamps
    end
  end
end
