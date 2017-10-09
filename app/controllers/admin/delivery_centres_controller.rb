module Admin
  class DeliveryCentresController < ApplicationController
    before_action :authorise_administrator!
    before_action :load_location
    before_action :load_delivery_centre, only: %i[edit update]

    def index
      @delivery_centres = @location
                          .delivery_centres
                          .includes(:users)
                          .order(:name)
    end

    def new
      @delivery_centre = @location.delivery_centres.build
    end

    def create
      @delivery_centre = @location.delivery_centres.build(delivery_centre_params)

      if @delivery_centre.save
        redirect_to admin_location_delivery_centres_path(@location), success: 'Delivery centre created.'
      else
        render :new
      end
    end

    def edit
      @delivery_centre = DeliveryCentre.find(params[:id])
    end

    def update
      @delivery_centre = DeliveryCentre.find(params[:id])

      if @delivery_centre.update(delivery_centre_params)
        redirect_to admin_location_delivery_centres_path(@location), success: 'Delivery centre updated.'
      else
        render :edit
      end
    end

    private

    def delivery_centre_params
      params.require(:delivery_centre).permit(:name, :reply_to)
    end

    def load_location
      @location ||= Location.find(params[:location_id])
    end

    def load_delivery_centre
      @delivery_centre ||= @location.delivery_centres.find(params[:id])
    end
  end
end
