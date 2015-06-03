Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV['GOOGLE_CLIENT_ID'],
           ENV['GOOGLE_CLIENT_SECRET'],
           scope: 'userinfo.profile,youtube.readonly,yt-analytics.readonly,youtubepartner-content-owner-readonly,youtubepartner',
           prompt: 'consent'
end