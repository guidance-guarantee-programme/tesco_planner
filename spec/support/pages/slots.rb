module Pages
  class Slots < SitePrism::Page
    set_url '/locations/{location_id}/availability'

    elements :slots, '.t-slot'
  end
end
