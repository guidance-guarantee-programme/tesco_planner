class SlackPingerJob < ApplicationJob
  queue_as :default

  def perform(appointment)
    return unless hook_uri

    json = payload(appointment.delivery_centre.location)
    WebHook.new(hook_uri).call(json)
  end

  private

  def hook_uri
    ENV['APPOINTMENTS_SLACK_PINGER_URI']
  end

  def payload(location)
    {
      username: 'tesco',
      channel: '#online-bookings',
      text: ":rotating_light: #{location.name} :rotating_light:",
      icon_emoji: ':tesco:'
    }
  end
end
