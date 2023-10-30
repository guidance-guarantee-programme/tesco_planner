source 'https://rubygems.org'

ruby IO.read('.ruby-version').chomp

source 'https://rails-assets.org' do
  gem 'rails-assets-alertifyjs'
  gem 'rails-assets-bootstrap-daterangepicker'
  gem 'rails-assets-fullcalendar', '3.4.0'
  gem 'rails-assets-fullcalendar-scheduler', '1.6.2'
  gem 'rails-assets-pusher', '~> 4.3'
end

gem 'active_model_serializers'
gem 'audited'
gem 'azure-storage-blob'
gem 'bootsnap', require: false
gem 'bootstrap-kaminari-views'
gem 'bugsnag'
gem 'email_validator'
gem 'faraday'
gem 'faraday-conductivity'
gem 'faraday_middleware'
gem 'gds-sso'
gem 'govuk_admin_template'
gem 'kaminari'
gem 'momentjs-rails'
gem 'notifications-ruby-client'
gem 'pg'
gem 'plek'
gem 'postgres-copy'
gem 'puma'
gem 'pusher'
gem 'rack-cors'
gem 'rails', '~> 6.0'
gem 'sassc-rails'
gem 'sidekiq', '< 7'
gem 'sinatra', require: false
gem 'sprockets-es6'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'capybara'
  gem 'factory_bot_rails', '4.11.0'
  gem 'phantomjs'
  gem 'pry-byebug'
  gem 'pusher-fake'
  gem 'rspec-rails'
  gem 'site_prism'
end

group :test do
  gem 'database_rewinder'
  gem 'launchy'
  gem 'poltergeist'
  gem 'webmock'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end

group :staging, :production do
  gem 'lograge'
  gem 'rails_12factor'
end
