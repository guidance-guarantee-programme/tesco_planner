module Pages
  class Availability < SitePrism::Page
    set_url '/locations/{location_id}/slots'

    elements :rooms, '.t-room'
  end
end
