class LocationSearch
  include ActiveModel::Model

  attr_accessor :location
  attr_accessor :scoped
  attr_accessor :page

  def locations
    scope = scoped.order(:name)
    scope = scope.where('name ilike ?', "%#{location}%") if location.present?

    scope.page(page)
  end
end
