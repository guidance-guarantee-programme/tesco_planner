class SlotsController < ApplicationController
  before_action :authorise_booking_manager!
  before_action :location

  def index
    respond_to do |format|
      format.html
      format.json { render json: slots }
    end
  end

  def create
    Slot.create!(
      room: location.rooms.find(params[:room_id]),
      start_at: params[:start_at]
    )

    head :created
  end

  def destroy
    location.slots.find(params[:id]).destroy

    head :no_content
  end

  private

  def location
    @location ||= current_user.locations.find(params[:location_id])
  end

  def slots
    location.slots.where(
      start_at: params[:start].to_date.beginning_of_day..params[:end].to_date.end_of_day
    )
  end
end
