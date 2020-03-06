module Api
  module V1
    class SearchesController < ActionController::Base
      include LogrageFilterer
      include GDS::SSO::ControllerMethods

      wrap_parameters false

      before_action :authorise_api_user!

      def index
        @results = AppointmentApiSearch.new(params[:query]).call

        render json: @results, each_serializer: AppointmentSearchSerializer
      end

      private

      def authorise_api_user!
        authorise_user!(User::API_USER)
      end
    end
  end
end
