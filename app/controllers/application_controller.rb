class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods
  include LogrageFilterer

  before_action :authenticate_user!

  protect_from_forgery with: :exception

  add_flash_types :success, :notice, :warning

  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.json { head :not_found }
    end
  end

  protected

  def authorise_administrator!
    authorise_user!(User::ADMINISTRATOR)
  end

  def authorise_booking_manager!
    authorise_user!(User::BOOKING_MANAGER)
  end
end
