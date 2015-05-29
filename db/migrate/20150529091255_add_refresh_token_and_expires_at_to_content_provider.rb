class AddRefreshTokenAndExpiresAtToContentProvider < ActiveRecord::Migration
  def change
    change_table :content_providers do |t|
      t.datetime :expires_at
      t.string :refresh_token
    end
  end
end
