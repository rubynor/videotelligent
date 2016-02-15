class CreateContentOwners < ActiveRecord::Migration
  def change
    create_table :content_owners do |t|
      t.string :uid
      t.string :name
      t.integer :content_provider_id

      t.timestamps null: false
    end
  end
end
