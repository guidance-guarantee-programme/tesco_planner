class LocationsController < ApplicationController
  before_action :authorise_booking_manager!

  def index
    @locations = current_user.locations.order(:name)
  end

  private

  def authorise_booking_manager!
    authorise_user!(User::BOOKING_MANAGER)
  end
end
