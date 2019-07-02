class AppointmentSearch
  include ActiveModel::Model

  attr_accessor :processed
  attr_accessor :reference
  attr_accessor :name
  attr_accessor :status
  attr_accessor :date
  attr_accessor :employer
  attr_accessor :location
  attr_accessor :user
  attr_accessor :page

  def results # rubocop:disable Metrics/AbcSize
    scope = user.appointments.includes(slot: { room: :location })
    scope = processed_scope(scope)
    scope = scope.where(id: reference) if reference.present?
    scope = scope.where('first_name ILIKE :name or last_name ILIKE :name', name: "%#{name}%") if name.present?
    scope = scope.where(status: status) if status.present?
    scope = scope.where(slots: { start_at: date_range }) if date.present?
    scope = employer_location_scope(scope)
    scope.order(created_at: :desc).page(page)
  end

  def employers
    user.delivery_centre.employers.order(:name)
  end

  private

  def employer_location_scope(scope)
    return scope.where(locations: { id: location }) if location.present?
    return scope.where(locations: { employer_id: employer }) if employer.present?

    scope
  end

  def processed_scope(scope)
    if ActiveRecord::Type::Boolean.new.cast(processed)
      scope.where.not(processed_at: nil)
    else
      scope.where(processed_at: nil)
    end
  end

  def date_range
    return if date.blank?

    first, last = date.split(' - ').map(&:to_date)
    first.beginning_of_day..last.end_of_day
  end
end
