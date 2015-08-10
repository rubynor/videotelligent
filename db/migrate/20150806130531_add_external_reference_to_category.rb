class AddExternalReferenceToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :external_reference, :string
  end
end
