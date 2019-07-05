module LocationsHelper
  def location_options(scope)
    scope.order(:name).pluck(:name)
  end

  def grouped_employer_locations(current_user)
    [].tap do |data|
      current_user.delivery_centre.employers.order(:name).each do |employer|
        filtered_locations = employer.locations.where(id: current_user.locations.pluck(:id)).order(:name)

        data << [employer.name, filtered_locations.pluck(:name, :id)]
      end
    end
  end
end
