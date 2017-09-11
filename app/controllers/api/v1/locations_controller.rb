module Api
  module V1
    class LocationsController < ActionController::Base
      def index
        render json: Location.order(:name).all
      end

      def show
        render json: location, include_slots: true
      end

      private

      def location
        @location ||= Location.find(params[:id])
      end
    end
  end
end
