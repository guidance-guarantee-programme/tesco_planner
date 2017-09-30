class HomeController < ApplicationController
  before_action :authorise_booking_manager!

  def index
    if current_user.assigned?
      redirect_to appointments_path, status: :moved_permanently
    else
      redirect_to edit_user_path
    end
  end
end
