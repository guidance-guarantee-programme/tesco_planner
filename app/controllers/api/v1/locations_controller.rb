module Api
  module V1
    class LocationsController < ActionController::Base
      include LogrageFilterer

      def index
        render json: Location.active.order(:name).all
      end

      def show
        render json: location, include_slots: true
      end

      private

      def location
        @location ||= Location.active.find(params[:id])
      end
    end
  end
end
