class SlotsController < ApplicationController
  before_action :authorise_booking_manager!

  def index
    @location = location
  end

  private

  def location
    current_user.locations.find(params[:location_id])
  end
end
