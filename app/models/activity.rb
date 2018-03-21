class Activity < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :appointment

  def to_partial_path
    "activities/#{model_name.singular}"
  end
end
