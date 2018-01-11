class ProcessesController < ApplicationController
  def create
    @appointment = Appointment.find(params[:appointment_id])
    @appointment.process!(current_user)

    redirect_back notice: 'The appointment was marked as processed.', fallback_location: root_path
  end
end
