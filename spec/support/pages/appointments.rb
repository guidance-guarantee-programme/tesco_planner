module Pages
  class Appointments < SitePrism::Page
    set_url '/appointments'

    elements :appointments, '.t-appointment'

    element :success, '.alert-success'
  end
end
