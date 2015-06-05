class AddDescriptionAndTagsToVideo < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.string :description
      t.string :tags
    end
  end
end
