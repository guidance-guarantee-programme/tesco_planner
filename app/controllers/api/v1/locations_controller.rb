module Api
  module V1
    class LocationsController < ActionController::Base
      def index
        render json: Location.order(:name).all
      end
    end
  end
end
