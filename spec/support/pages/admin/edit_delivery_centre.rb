module Pages
  module Admin
    class EditDeliveryCentre < SitePrism::Page
      set_url '/admin/locations/{location_id}/delivery_centres/{id}/edit'

      elements :assigned_booking_managers, '.t-assigned-booking-manager'

      element :booking_managers, '.t-booking-managers'
      element :submit, '.t-submit'
    end
  end
end
