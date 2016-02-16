class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :videos, :category_id
    add_index :view_stats, :video_id
  end
end