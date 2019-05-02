module Api
  module V1
    class EmployersController < ActionController::Base
      include LogrageFilterer

      def show
        render json: employer
      end

      private

      def employer
        Employer.includes(:locations).find(params[:id])
      end
    end
  end
end
