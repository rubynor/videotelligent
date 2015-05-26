class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :link
      t.string :title
      t.datetime :published_at
      t.integer :likes
      t.integer :dislikes
      t.string :uid
      t.string :thumbnail_url

      t.timestamps null: false
    end
    add_index :videos, :uid
  end
end
