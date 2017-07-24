class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods

  protect_from_forgery with: :exception

  before_action :require_signin_permission!
end
