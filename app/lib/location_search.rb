class LocationSearch
  include ActiveModel::Model

  attr_accessor :location
  attr_accessor :current_user
  attr_accessor :page

  def locations
    scope = current_user.locations.order(:name)
    scope = scope.where('name ilike ?', "%#{location}%") if location.present?

    scope.page(page)
  end
end
