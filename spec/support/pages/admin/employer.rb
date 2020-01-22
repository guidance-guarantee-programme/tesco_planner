module Pages
  module Admin
    class Employer < SitePrism::Page
      set_url '/admin/employers/new'

      element :name, '.t-name'
      element :url_fragment, '.t-url'
      element :delivery_centres, '.t-delivery-centres'

      element :submit, '.t-submit'
    end
  end
end
