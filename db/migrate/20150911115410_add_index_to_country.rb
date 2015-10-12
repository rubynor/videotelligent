class AddIndexToCountry < ActiveRecord::Migration
  def change
    add_index :view_stats, :country
  end
end
