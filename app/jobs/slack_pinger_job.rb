class SlackPingerJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    return unless hook_uri

    json = payload(appointment.location)
    WebHook.new(hook_uri).call(json)
  end

  private

  def hook_uri
    ENV['APPOINTMENTS_SLACK_PINGER_URI']
  end

  def payload(location)
    appointments = location.appointments.size
    slots = location.slots.size

    {
      username: 'employer',
      channel: '#online-bookings',
      text: ":rotating_light: #{location.name} #{appointments}/#{slots} :rotating_light:",
      icon_emoji: ':factory:'
    }
  end
end
