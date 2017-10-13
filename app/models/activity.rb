class Activity < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :appointment

  default_scope { order(created_at: :desc) }

  def to_partial_path
    "activities/#{model_name.singular}"
  end
end
