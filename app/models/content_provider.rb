require 'faraday/middleware'

class ContentProvider < ActiveRecord::Base
  belongs_to :user, foreign_key: :uid, primary_key: :uid
  has_many :content_owners

  def self.from_omniauth(auth)
    content_provider = ContentProvider.find_or_initialize_by(uid: auth['uid'])
    content_provider.name = auth['info']['name']
    content_provider.token = auth['credentials']['token']
    content_provider.expires_at = Time.at(auth['credentials']['expires_at'])

    if auth['credentials']['refresh_token'].present?
      content_provider.refresh_token = auth['credentials']['refresh_token']
    end

    content_provider.save!
    content_provider
  end

end
