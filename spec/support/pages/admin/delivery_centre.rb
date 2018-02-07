module Pages
  module Admin
    class DeliveryCentre < SitePrism::Page
      set_url '/admin/delivery_centres/new'

      element :name, '.t-name'
      element :reply_to, '.t-reply-to'
      element :submit, '.t-submit'
    end
  end
end
