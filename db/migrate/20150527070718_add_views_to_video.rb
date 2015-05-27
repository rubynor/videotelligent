class AddViewsToVideo < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.integer :views
    end
  end
end
