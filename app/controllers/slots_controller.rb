class SlotsController < ApplicationController
  before_action :authorise_booking_manager!

  def index
    @location = location

    respond_to do |format|
      format.html
      format.json { render json: slots }
    end
  end

  private

  def location
    current_user.locations.find(params[:location_id])
  end

  def slots
    @location.slots.where(
      start_at: params[:start].to_date.beginning_of_day..params[:end].to_date.end_of_day
    )
  end
end
