class LocationsController < ApplicationController
  before_action :authorise_booking_manager!

  def index
    @search    = LocationSearch.new(location_search_params)
    @locations = @search.locations
  end

  private

  def location_search_params
    params
      .fetch(:search, {})
      .permit(:location)
      .merge(
        scoped: current_user.locations,
        page: params[:page]
      )
  end
end
