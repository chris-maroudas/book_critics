class DropIdentity < ActiveRecord::Migration
  def change
    drop_table :identities
  end
end
