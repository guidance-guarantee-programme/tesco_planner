module LocationsHelper
  def location_options(current_user)
    current_user.locations.order(:name).pluck(:name)
  end
end
