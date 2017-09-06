module Api
  module V1
    class SlotsController < ActionController::Base
      def index
        render json: location.windowed_slots
      end

      private

      def location
        Location.find(params[:location_id])
      end
    end
  end
end
