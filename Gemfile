source "https://rubygems.org"

ruby "2.2.2"
gem "rails", "4.2.2"

gem "active_model_serializers"
gem "activerecord-import"
gem "autoprefixer-rails"
gem "bourbon", "~> 4.2.0"
gem "coffee-rails", "~> 4.1.0"
gem "delayed_job_active_record"
gem "email_validator"
gem "faraday_middleware"
gem "flutie"
gem 'font-awesome-rails'
gem "haml-rails"
gem "haml_coffee_assets", git: "https://github.com/netzpirat/haml_coffee_assets"
gem "high_voltage"
gem 'honeybadger', '~> 2.0'
gem "i18n-tasks"
gem "jquery-rails"
gem "neat", "~> 1.7.0"
gem "newrelic_rpm", ">= 3.9.8"
gem "normalize-rails", "~> 3.0.0"
gem 'omniauth-google-oauth2'
gem "pg"
gem "quiet_assets"
gem "rack-canonical-host"
gem "recipient_interceptor"
gem "responders"
gem "sass-rails", "~> 5.0"
gem "simple_form"
gem "title"
gem "uglifier"
gem "unicorn"
gem "viddl-rb"
# TODO: Change this to original gem once PR has been merged
gem "yt", git: "https://github.com/karianne/yt", branch: "fix-refresh-token-for-content-owners" #"~> 0.24.1"
gem 'whenever', :require => false
gem "will_paginate"

group :development do
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console"
  gem 'seed_dump', require: false
end

group :development, :test do
  gem "awesome_print"
  gem "bundler-audit", require: false
  gem "byebug"
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.1.0"
end

group :test do
  gem "capybara-webkit", ">= 1.2.0"
  gem "database_cleaner"
  gem "formulaic"
  gem "launchy"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rails_stdout_logging"
  gem "rack-timeout"
  gem "rails_12factor"
end
