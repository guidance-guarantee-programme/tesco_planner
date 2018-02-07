class SlotSearch
  include ActiveModel::Model

  attr_accessor :date
  attr_accessor :location
  attr_accessor :available
  attr_accessor :room
  attr_accessor :page

  def results
    scope = Slot.includes(room: :location).where(locations: { id: location.id })
    scope = scope.where(start_at: date_range)
    scope = availability(scope)
    scope = scope.order(:start_at)
    scope.page(page)
  end

  private

  def availability(scope)
    scope = scope.includes(:appointment)

    case available
    when 'Yes'
      scope.where(appointments: { id: nil })
    when 'No'
      scope.where.not(appointments: { id: nil })
    else
      scope
    end
  end

  def date_range
    if date.blank?
      Time.current.beginning_of_month..Time.current.end_of_month
    else
      first, last = date.split(' - ').map(&:to_date)
      first.beginning_of_day..last.end_of_day
    end
  end
end
