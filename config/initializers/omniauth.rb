Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           '663769004258-qq4kbh4jrisi4ucuuhfd7aeafekfhnp1.apps.googleusercontent.com',
           'eeXo1e1wUZs2XbIERDmdNHFy',
           scope: 'userinfo.profile,youtube.readonly'
end