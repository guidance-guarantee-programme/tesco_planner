class RoomSerializer < ActiveModel::Serializer
  attribute :id
  attribute :name, key: :title
end
