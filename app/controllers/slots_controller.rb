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
    current_user.slots.create!(
      room: room,
      start_at: params[:start_at]
    )

    head :created
  end

  def destroy
    location.slots.find(params[:id]).destroy

    head :no_content
  end

  private

  def room
    location.rooms.find(params[:room_id])
  end

  def location
    @location ||= current_user.location
  end

  def slots
    starts = params[:start].to_date.beginning_of_day
    ends   = params[:end].to_date.end_of_day

    location.slots.where(start_at: starts..ends)
  end
end
