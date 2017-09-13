module Api
  module V1
    class AppointmentsController < ActionController::Base
      def create
        @appointment = Appointment.new(appointment_params.merge(slot: slot))

        if @appointment.save
          head :created, location: @appointment
        else
          render json: @appointment.errors, status: :unprocessable_entity
        end
      end

      private

      def appointment_params
        params.permit(
          :first_name,
          :last_name,
          :email,
          :phone,
          :memorable_word,
          :date_of_birth,
          :dc_pot_confirmed,
          :opt_out_of_market_research
        )
      end

      def slot
        @slot ||= location.slots.find_by(start_at: params[:start_at])
      end

      def location
        @location ||= Location.find(params[:location_id])
      end
    end
  end
end
