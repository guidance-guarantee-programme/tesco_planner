module Pages
  module Admin
    class Employers < SitePrism::Page
      set_url '/admin/employers'

      element :success, '.alert-success'

      sections :employers, '.t-employer' do
        element :name, '.t-name'
        element :url, '.t-url'
        element :delivery_centres, '.t-delivery-centres'
      end
    end
  end
end
