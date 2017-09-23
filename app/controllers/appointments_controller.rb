class AppointmentsController < ApplicationController
  before_action :authorise_booking_manager!
  before_action :load_appointment, only: %i[edit update]

  def index
    @appointments = current_user.appointments

    respond_to do |format|
      format.html { @appointments = @appointments.page(params[:page]) }
      format.json { render json: windowed(@appointments) }
    end
  end

  def edit
  end

  def update
    if @appointment.update(appointment_params)
      send_notifications(@appointment)
      redirect_to appointments_path, success: 'The appointment was updated.'
    else
      render :edit
    end
  end

  private

  def windowed(appointments)
    starts = params[:start].to_date.beginning_of_day
    ends   = params[:end].to_date.end_of_day

    appointments.includes(:slot).where(slots: { start_at: starts..ends })
  end

  def send_notifications(appointment)
    return unless appointment.status_previously_changed? && appointment.cancelled?

    CancellationNotificationJob.perform_later(appointment.object)
  end

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
      current_user
        .appointments
        .includes(activities: :user)
        .find(params[:id])
    )
  end
end
