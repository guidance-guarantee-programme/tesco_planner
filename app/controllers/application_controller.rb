class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    User.new
  end
  helper_method :current_user
end
