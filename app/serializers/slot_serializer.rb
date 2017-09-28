class SlotSerializer < ActiveModel::Serializer
  attribute :id
  attribute :start_at, key: :start
  attribute :end_at, key: :end
  attribute :room_id, key: :resourceId

  attribute :mine do
    current_user.mine?(object)
  end
end
