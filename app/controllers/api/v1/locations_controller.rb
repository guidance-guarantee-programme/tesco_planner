module Api
  module V1
    class LocationsController < ActionController::Base
      include LogrageFilterer

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
