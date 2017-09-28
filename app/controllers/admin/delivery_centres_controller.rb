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
      @booking_managers = User.unassigned_booking_managers.pluck(:name, :id)
      @assigned_users   = @delivery_centre.users.order(:name)
    end

    def update
      if params[:user_id].present?
        User.update(params[:user_id], delivery_centre: @delivery_centre)
        options = { success: 'Booking manager assigned.' }
      else
        options = { warning: 'Choose a booking manager to assign.' }
      end

      redirect_back options.merge(fallback_location: root_path)
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
