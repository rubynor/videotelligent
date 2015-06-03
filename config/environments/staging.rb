require_relative "production"

Mail.register_interceptor(
  RecipientInterceptor.new(ENV.fetch("EMAIL_RECIPIENTS"))
)

Videotelligent::Application.configure do
  config.middleware.insert_after(::Rack::Runtime, "::Rack::Auth::Basic", "Staging") do |u, p|
    [u, p] == ['video', 'ingen ku uten rockering']
  end
end

Rails.application.configure do
  # ...

  config.action_mailer.default_url_options = { host: ENV.fetch("HOST") }
end
