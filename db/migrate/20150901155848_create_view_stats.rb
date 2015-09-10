class CreateViewStats < ActiveRecord::Migration
  def change
    create_table :view_stats do |t|
      t.references :video
      t.string :country
      t.string :gender
      t.string :age_group
      t.integer :number_of_views
      t.timestamps null: false
    end
  end
end
