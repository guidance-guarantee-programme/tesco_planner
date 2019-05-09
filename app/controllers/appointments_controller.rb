class AppointmentsController < ApplicationController
  before_action :authorise_booking_manager!
  before_action :load_appointment, only: %i[edit update]

  def index
    respond_to do |format|
      format.html do
        @search = AppointmentSearch.new(search_params)
        @appointments = @search.results
      end
      format.json { render json: windowed(current_user.appointments) }
    end
  end

  def edit
  end

  def update
    if @appointment.update(appointment_params)
      handle_cancellation(@appointment.object)
      handle_notification(@appointment.object)
      redirect_to appointments_path, success: 'The appointment was updated.'
    else
      render :edit
    end
  end

  private

  def search_params # rubocop:disable MethodLength
    params
      .fetch(:search, {})
      .permit(
        :reference,
        :name,
        :status,
        :date,
        :employer,
        :location,
        :processed
      ).merge(
        page: params[:page],
        user: current_user
      )
  end

  def windowed(appointments)
    starts = params[:start].to_date.beginning_of_day
    ends   = params[:end].to_date.end_of_day

    appointments
      .includes(slot: :room)
      .where(
        slots: { start_at: starts..ends },
        rooms: { location_id: params[:location_id] }
      )
  end

  def handle_cancellation(appointment)
    appointment.handle_cancellation! do
      EmailActivity.from(appointment)
      AppointmentMailer.cancellation(appointment).deliver_later
    end
  end

  def handle_notification(appointment)
    return unless appointment.notify?

    EmailActivity.from(appointment)
    AppointmentMailer.customer(appointment).deliver_later
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
        :gdpr_consent
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
