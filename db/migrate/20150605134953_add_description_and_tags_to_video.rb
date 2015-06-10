class AddDescriptionAndTagsToVideo < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.string :description
      t.string :tags
      t.string :category_title
      t.string :channel_title
    end
  end
end
