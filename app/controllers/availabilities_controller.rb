class AvailabilitiesController < ApplicationController
  before_action :authorise_booking_manager!

  def show
    @search = SlotSearch.new(search_params)
    @slots  = @search.results
  end

  private

  def search_params
    params
      .fetch(:search, {})
      .permit(:date, :room, :available)
      .merge(
        page: params[:page],
        location: location
      )
  end

  def rooms
    @rooms ||= location.rooms.order(:name)
  end
  helper_method :rooms

  def location
    @location ||= current_user.locations.find(params[:location_id])
  end
  helper_method :location
end
