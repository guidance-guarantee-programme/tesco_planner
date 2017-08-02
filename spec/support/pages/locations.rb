module Pages
  class Locations < SitePrism::Page
    set_url '/locations'

    sections :locations, '.t-location' do
      element :name, '.t-name'
      element :town, '.t-town'
      element :county, '.t-county'
      element :availability, '.t-availability'

      sections :rooms, '.t-rooms' do
        element :room, '.t-room'
      end
    end
  end
end
