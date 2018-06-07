module Admin
  class AppointmentsController < ApplicationController
    before_action :authorise_administrator!

    def index
      if @appointment = Appointment.find_by(id: params[:id]) # rubocop:disable AssignmentInCondition
        reassign_delivery_centre(@appointment)

        redirect_to edit_appointment_path(@appointment)
      else
        redirect_back warning: "The appointment '#{params[:id]}' could not be found.", fallback_location: root_path
      end
    end

    private

    def reassign_delivery_centre(appointment)
      current_user.assign!(appointment.delivery_centre)
    end
  end
end
