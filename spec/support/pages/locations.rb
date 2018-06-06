module Pages
  class Locations < SitePrism::Page
    set_url '/locations'

    element :select2, '.select2-container'
  end
end
