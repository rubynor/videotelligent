Yt.configure do |config|
  config.api_key = ENV['GOOGLE_API_KEY']
  config.log_level = :devel # This outputs curl strings to stdout for the requests
  # Necessary for now (also set in omniauth.rb) because of https://github.com/Fullscreen/yt/issues/189
  config.client_id = ENV['GOOGLE_CLIENT_ID']
  config.client_secret = ENV['GOOGLE_CLIENT_SECRET']
end