class CreateContentProviders < ActiveRecord::Migration
  def change
    create_table :content_providers do |t|
      t.string :name
      t.string :token
      t.string :uid

      t.timestamps null: false
    end
    add_index :content_providers, :uid, unique: true
  end
end
