require 'faraday'
require 'faraday/conductivity'

class CloudflareForwarding
  def initialize(bearer_token, zone_id)
    @bearer_token = bearer_token
    @zone_id = zone_id
  end

  def call(employer)
    connection.post do |request|
      request.body = json_payload(employer)
    end
  end

  private

  def json_payload(employer) # rubocop:disable MethodLength
    {
      targets: [
        target: 'url',
        constraint: {
          operator: 'matches',
          value: "https://www.pensionwise.gov.uk/#{employer.url}"
        }
      ],
      actions: [
        id: 'forwarding_url',
        value: {
          url: "https://www.pensionwise.gov.uk/en/employers/#{employer.id}/locations",
          status_code: 301 # Permanent Redirect
        }
      ],
      priority: 10,
      status: 'active'
    }
  end

  def connection
    @connection ||= Faraday.new(connection_options) do |faraday|
      faraday.request  :json
      faraday.response :raise_error
      faraday.use      :instrumentation
      faraday.adapter  Faraday.default_adapter
      faraday.authorization :Bearer, bearer_token
    end
  end

  def connection_options
    {
      url: "https://api.cloudflare.com/client/v4/zones/#{zone_id}/pagerules",
      request: {
        timeout: Integer(ENV.fetch('CLOUDFLARE_TIMEOUT', 2)),
        open_timeout: Integer(ENV.fetch('CLOUDFLARE_OPEN_TIMEOUT', 2))
      }
    }
  end

  attr_reader :bearer_token
  attr_reader :zone_id
end
