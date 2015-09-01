class AddDateToViewStats < ActiveRecord::Migration
  def change
    add_column :view_stats, :on_date, :date
  end
end
