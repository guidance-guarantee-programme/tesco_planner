class EmployerSerializer < ActiveModel::Serializer
  attribute :name

  has_many :locations do
    object.locations.active.order(:name)
  end
end
