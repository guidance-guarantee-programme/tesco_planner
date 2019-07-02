class LocationSearch
  include ActiveModel::Model

  attr_accessor :employer
  attr_accessor :location
  attr_accessor :user
  attr_accessor :scoped
  attr_accessor :page

  def locations
    scope = scoped
    scope = scope.where(locations: { id: location }) if location.present?
    scope = scope.where(locations: { employer_id: employer }) if employer.present?
    scope = scope.order(:name)

    scope.page(page)
  end
end
