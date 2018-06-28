class Activity < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :appointment

  def to_partial_path
    "activities/#{model_name.singular}"
  end

  def owner
    user ? user.name : 'Someone'
  end

  def self.from(appointment)
    create!(appointment: appointment)
  end
end
