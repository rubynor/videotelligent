class AddViewsByWeekToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :views_last_week, :integer, default: 0
  end
end
