module Api
  module V1
    class AppointmentsController < ActionController::Base
      include LogrageFilterer

      wrap_parameters false

      def create
        @appointment = Appointment.new(appointment_params.merge(slot: slot))

        if @appointment.save
          deliver_notifications(@appointment)
          render json: AppointmentDecorator.new(@appointment).to_h, status: :created
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
          :gdpr_consent
        )
      end

      def slot
        @slot ||= location.available_slot(params[:start_at])
      end

      def location
        @location ||= Location.find(params[:location_id])
      end

      def deliver_notifications(appointment)
        AppointmentMailer.customer(appointment).deliver_later
        SlackPingerJob.perform_later(appointment)

        appointment.booking_managers.each do |booking_manager|
          AppointmentMailer.booking_manager(booking_manager).deliver_later
        end
      end
    end
  end
end
