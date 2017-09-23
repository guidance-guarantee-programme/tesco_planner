class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :appointment

  default_scope { order(created_at: :desc) }
end
