class PusherNotificationJob < ApplicationJob
  queue_as :default

  def perform(activity)
    Pusher.trigger(
      'pension_wise_tesco',
      "appointment_activity_#{activity.appointment_id}",
      body: render_activity(activity)
    )
  end

  private

  def render_activity(activity)
    ApplicationController.render(partial: activity, locals: { hide: false })
  end
end
