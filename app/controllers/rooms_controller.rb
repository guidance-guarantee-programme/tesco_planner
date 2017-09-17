class RoomsController < ApplicationController
  before_action :authorise_booking_manager!

  def index
    render json: rooms
  end

  private

  def rooms
    current_user.location.rooms.order(:name)
  end
end
