module Pages
  module Admin
    class Location < SitePrism::Page
      set_url '/admin/locations/new'

      element :delivery_centre, '.t-delivery-centre'
      element :name, '.t-name'
      element :address_line_one, '.t-address-line-one'
      element :address_line_two, '.t-address-line-two'
      element :address_line_three, '.t-address-line-three'
      element :town, '.t-town'
      element :county, '.t-county'
      element :postcode, '.t-postcode'
      element :active, '.t-active'
      element :submit, '.t-submit'
    end
  end
end
