# Silence OmniAuth's output in test
OmniAuth.config.logger = Rails.logger if Rails.env.test?
