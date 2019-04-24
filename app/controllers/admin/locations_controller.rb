module Admin
  class LocationsController < ApplicationController
    before_action :authorise_administrator!
    before_action :load_delivery_centres
    before_action :load_employers, except: :index

    def index
      @search    = LocationSearch.new(location_search_params)
      @locations = @search.locations
    end

    def edit
      @location = Location.find(params[:id])
    end

    def update
      @location = Location.find(params[:id])

      if @location.update(location_params)
        redirect_to admin_locations_path, success: 'Location updated.'
      else
        render :edit
      end
    end

    def new
      @location = Location.new
    end

    def create
      @location = Location.new(location_params)

      if @location.save
        redirect_to admin_locations_path, success: 'Location created.'
      else
        render :new
      end
    end

    private

    def location_search_params
      params
        .fetch(:search, {})
        .permit(:location)
        .merge(
          scoped: Location.all,
          page: params[:page]
        )
    end

    def load_delivery_centres
      @delivery_centres = DeliveryCentre.order(:name)
    end

    def load_employers
      @employers = Employer.order(:name)
    end

    def location_params # rubocop:disable Metrics/MethodLength
      params
        .require(:location)
        .permit(
          :employer_id,
          :delivery_centre_id,
          :name,
          :address_line_one,
          :address_line_two,
          :address_line_three,
          :town,
          :county,
          :postcode,
          :active
        )
    end
  end
end
