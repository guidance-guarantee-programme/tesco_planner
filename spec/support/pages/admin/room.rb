module Pages
  module Admin
    class Room < SitePrism::Page
      set_url '/admin/locations/{location_id}/rooms/new'

      element :name, '.t-name'
      element :submit, '.t-submit'
    end
  end
end
