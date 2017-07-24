source 'https://rubygems.org'

ruby IO.read('.ruby-version').chomp

gem 'govuk_admin_template'
gem 'pg', '~> 0.18'
gem 'plek'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.2'
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', '~> 0.47.1', require: false
end

group :staging, :production do
  gem 'rails_12factor'
end
