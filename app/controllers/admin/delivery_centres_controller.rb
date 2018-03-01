module Admin
  class DeliveryCentresController < ApplicationController
    before_action :authorise_administrator!

    def index
      @delivery_centres = DeliveryCentre.includes(:users).order(:name)
    end

    def new
      @delivery_centre = DeliveryCentre.new
    end

    def create
      @delivery_centre = DeliveryCentre.new(delivery_centre_params)

      if @delivery_centre.save
        redirect_to admin_delivery_centres_path, success: 'Delivery centre created.'
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
        redirect_to admin_delivery_centres_path, success: 'Delivery centre updated.'
      else
        render :edit
      end
    end

    private

    def delivery_centre_params
      params.require(:delivery_centre).permit(:name, :reply_to, :hidden)
    end
  end
end
