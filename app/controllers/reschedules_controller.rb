class ReschedulesController < ApplicationController
  before_action :authorise_booking_manager!
  before_action :load_appointment_and_slots

  def edit
  end

  def update
    if @appointment.update(appointment_params)
      notify_customer(@appointment)
      redirect_to appointments_path, success: 'The appointment was rescheduled.'
    else
      render :edit
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:slot_id)
  end

  def load_appointment_and_slots
    @slots = current_user.slots.available.from_tomorrow.order(:start_at)

    @appointment = AppointmentDecorator.new(
      current_user.appointments.find(params[:appointment_id])
    )
  end

  def notify_customer(appointment)
    CustomerNotificationJob.perform_later(appointment.object)
  end
end
