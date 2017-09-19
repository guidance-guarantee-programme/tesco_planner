class AppointmentsController < ApplicationController
  before_action :authorise_booking_manager!
  before_action :load_appointment, only: %i[edit update]

  def index
    @appointments = current_user.appointments.page(params[:page])
  end

  def edit
  end

  def update
    if @appointment.update(appointment_params)
      redirect_to appointments_path, success: 'The appointment was updated.'
    else
      render :edit
    end
  end

  private

  def appointment_params # rubocop:disable Metrics/MethodLength
    params
      .require(:appointment)
      .permit(
        :first_name,
        :last_name,
        :email,
        :phone,
        :memorable_word,
        :status,
        :date_of_birth,
        :dc_pot_confirmed,
        :opt_out_of_market_research
      )
  end

  def load_appointment
    @appointment = AppointmentDecorator.new(
      current_user.appointments.find(params[:id])
    )
  end
end
