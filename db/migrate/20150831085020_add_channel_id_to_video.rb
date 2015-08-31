class AddChannelIdToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :channel_id, :string
  end
end
