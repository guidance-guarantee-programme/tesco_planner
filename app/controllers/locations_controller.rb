class LocationsController < ApplicationController
  before_action :authorise_booking_manager!

  def index
    @search = LocationSearch.new(location_search_params)
  end

  private

  def employers
    @employers ||= current_user.delivery_centre.employers.order(:name)
  end
  helper_method :employers

  def location_search_params
    params
      .fetch(:search, {})
      .permit(:location)
      .merge(
        user: current_user,
        scoped: current_user.locations.order(:name),
        page: params[:page]
      )
  end
end
