module LocationsHelper
  def location_options(scope)
    scope.order(:name).pluck(:name)
  end
end
