class AddViewStatIndexesToAgeGroupGenderAndOnDate < ActiveRecord::Migration
  def change
    add_index :view_stats, :age_group
    add_index :view_stats, :gender
    add_index :view_stats, :on_date
  end
end
