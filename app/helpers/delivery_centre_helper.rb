module DeliveryCentreHelper
  def delivery_centre_options
    DeliveryCentre.order(:name).visible.pluck(:name, :id)
  end
end
