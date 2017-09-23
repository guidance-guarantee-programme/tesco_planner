class ActivitiesController < ApplicationController
  before_action :authorise_booking_manager!

  def create
    @activity = appointment.activities.create(activity_params)
    send_push_notifications(@activity)

    respond_to do |format|
      format.js { render @activity }
    end
  end

  private

  def send_push_notifications(activity)
    PusherNotificationJob.perform_later(activity)
  end

  def appointment
    @appointment ||= current_user.appointments.find(params[:appointment_id])
  end

  def activity_params
    params
      .require(:activity)
      .permit(:message)
      .merge(user: current_user)
  end
end
