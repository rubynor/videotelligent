class AddContentOwnerIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :content_owner_id, :string
  end
end
