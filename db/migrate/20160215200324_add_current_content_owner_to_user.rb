class AddCurrentContentOwnerToUser < ActiveRecord::Migration
  def change
    add_column :users, :current_content_owner_id, :integer
  end
end
