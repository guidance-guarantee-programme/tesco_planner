module Admin
  class LocationsController < ApplicationController
    before_action :authorise_administrator!

    def index
      @locations = Location.all.order(:name).page(params[:page])
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

    def location_params # rubocop:disable Metrics/MethodLength
      params
        .require(:location)
        .permit(
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
