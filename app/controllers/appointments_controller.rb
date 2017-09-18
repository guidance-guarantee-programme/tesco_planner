class AppointmentsController < ApplicationController
  before_action :authorise_booking_manager!

  def index
    @appointments = current_user.appointments.page(params[:page])
  end
end
