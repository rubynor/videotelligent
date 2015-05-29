require 'faraday/middleware'

class ContentProvider < ActiveRecord::Base
  def self.from_omniauth(auth)

    content_provider = ContentProvider.find_or_initialize_by(uid: auth['uid'])
    content_provider.name = auth['info']['name']
    content_provider.token = auth['credentials']['token']
    content_provider.refresh_token = auth['credentials']['refresh_token']
    content_provider.expires_at = Time.at(auth['credentials']['expires_at'])

    content_provider.save!
    content_provider
  end

  # TODO: Temporary solution, should add some kind of response filter that refreshes token on a 401
  # TODO  since the value we get in expired_at isn't all that reliable
  def valid_token
    if current_token_still_valid
      return token
    end

    Rails.logger.debug("Current access token for #{name} expired, trying to fetch new one")

    refresh_token!
  end

  private
  def refresh_token!
    conn = Faraday.new('https://accounts.google.com') do |conn|
      conn.request :url_encoded
      conn.response :json
      conn.response :raise_error
      conn.response :logger unless Rails.env.production?
      conn.adapter Faraday.default_adapter
    end
    response = conn.post('/o/oauth2/token', {
                                              grant_type: 'refresh_token',
                                              refresh_token: refresh_token,
                                              client_id: ENV['GOOGLE_CLIENT_ID'],
                                              client_secret: ENV['GOOGLE_CLIENT_SECRET']
                                          })

    body = response.body

    self.token = body['access_token'] if body['access_token']
    self.expires_at = Time.now.utc + body['expires_in'].to_i
    save!
    token
  end

  def current_token_still_valid
    expires_at > Time.now.utc
  end
end