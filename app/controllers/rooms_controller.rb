class RoomsController < ApplicationController
  before_action :authorise_booking_manager!

  def index
    render json: rooms
  end

  private

  def location
    current_user.locations.find(params[:location_id])
  end

  def rooms
    location.rooms.order(:name)
  end
end
