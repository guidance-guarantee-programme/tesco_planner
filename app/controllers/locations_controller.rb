class LocationsController < ApplicationController
  before_action :authorise_booking_manager!

  def index
    @locations = current_user.locations.order(:name)
  end
end