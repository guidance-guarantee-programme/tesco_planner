# rubocop:disable Metrics/BlockLength
ruby IO.read('.ruby-version').chomp

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap-daterangepicker'
  gem 'rails-assets-fullcalendar', '3.4.0'
  gem 'rails-assets-fullcalendar-scheduler'
end

source 'https://rubygems.org' do
  gem 'active_model_serializers'
  gem 'gds-sso'
  gem 'govuk_admin_template'
  gem 'momentjs-rails'
  gem 'pg', '~> 0.18'
  gem 'plek'
  gem 'puma'
  gem 'rails', '~> 5.1.2'
  gem 'sassc-rails'
  gem 'sidekiq'
  gem 'sinatra', require: false
  gem 'sprockets-es6'
  gem 'uglifier', '>= 1.3.0'

  group :development, :test do
    gem 'capybara'
    gem 'factory_girl_rails'
    gem 'phantomjs'
    gem 'pry-byebug'
    gem 'rspec-rails'
    gem 'site_prism'
  end

  group :test do
    gem 'database_rewinder'
    gem 'launchy'
    gem 'poltergeist'
  end

  group :development do
    gem 'listen', '>= 3.0.5', '< 3.2'
    gem 'rubocop', require: false
  end

  group :staging, :production do
    gem 'rails_12factor'
  end
end
