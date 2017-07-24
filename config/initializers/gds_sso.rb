GDS::SSO.config do |config|
  config.cache      = Rails.cache
  config.user_model = 'User'
  config.oauth_id   = ENV['OAUTH_ID']
  config.oauth_root_url = ENV.fetch('OAUTH_ROOT_URL') { 'http://localhost:3006' }
  config.oauth_secret   = ENV['OAUTH_SECRET']
end
