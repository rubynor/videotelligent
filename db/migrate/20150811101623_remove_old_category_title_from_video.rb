class RemoveOldCategoryTitleFromVideo < ActiveRecord::Migration
  def change

    remove_column :videos, :category_title

  end
end
