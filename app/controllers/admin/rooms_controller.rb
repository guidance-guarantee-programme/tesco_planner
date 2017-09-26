module Admin
  class RoomsController < ApplicationController
    before_action :authorise_administrator!
    before_action :load_location

    def index
      @rooms = @location.rooms.order(:name)
    end

    def new
      @room = @location.rooms.build
    end

    def create
      @room = @location.rooms.build(room_params)

      if @room.save
        redirect_to admin_location_rooms_path(@location), success: 'Room created.'
      else
        render :new
      end
    end

    private

    def room_params
      params.require(:room).permit(:name)
    end

    def load_location
      @location ||= Location.find(params[:location_id])
    end
  end
end
