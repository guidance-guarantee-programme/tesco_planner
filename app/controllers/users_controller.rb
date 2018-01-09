class UsersController < ApplicationController
  before_action :authorise_booking_manager!
  before_action :load_locations

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to appointments_path, success: 'Your delivery centres have been assigned.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(delivery_centre_ids: [])
  end

  def load_locations
    @locations = Location
                 .joins(:delivery_centres)
                 .all
                 .order('locations.name, delivery_centres.name')
  end
end
