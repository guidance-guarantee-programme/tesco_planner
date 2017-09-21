module Pages
  class RescheduleAppointment < SitePrism::Page
    set_url '/appointments/{appointment_id}/reschedule/edit'

    element :slots, '.t-slots'
    element :submit, '.t-submit'
  end
end
