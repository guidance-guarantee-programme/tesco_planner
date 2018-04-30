class UsersController < ApplicationController
  before_action :authorise_booking_manager!

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to appointments_path, success: 'Your delivery centre has been assigned.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:delivery_centre_id)
  end
end
