# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'pusher-fake/support/rspec'

# Add additional requires below this line. Rails is not loaded until this point!
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include ActiveJob::TestHelper
  config.include ActiveSupport::Testing::TimeHelpers
  config.include FactoryGirl::Syntax::Methods
  config.include UserHelpers

  config.after(:each) { ActionMailer::Base.deliveries.clear }
end
