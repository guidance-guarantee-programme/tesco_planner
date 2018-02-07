class AppointmentSearch
  include ActiveModel::Model

  attr_accessor :reference
  attr_accessor :name
  attr_accessor :status
  attr_accessor :date
  attr_accessor :location
  attr_accessor :user
  attr_accessor :page

  def results # rubocop:disable Metrics/AbcSize
    scope = user.appointments.includes(slot: { room: :location })
    scope = scope.where(id: reference) if reference.present?
    scope = scope.where('first_name ILIKE :name or last_name ILIKE :name', name: "%#{name}%") if name.present?
    scope = scope.where(status: status) if status.present?
    scope = scope.where(slots: { start_at: date_range }) if date.present?
    scope = scope.where(locations: { id: location }) if location.present?
    scope.page(page)
  end

  def locations
    user.locations.order(:name)
  end

  private

  def date_range
    return if date.blank?

    first, last = date.split(' - ').map(&:to_date)
    first.beginning_of_day..last.end_of_day
  end
end
