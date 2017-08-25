class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods

  protect_from_forgery with: :exception

  before_action :require_signin_permission!

  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.json { head :not_found }
    end
  end

  protected

  def authorise_booking_manager!
    authorise_user!(User::BOOKING_MANAGER)
  end
end
