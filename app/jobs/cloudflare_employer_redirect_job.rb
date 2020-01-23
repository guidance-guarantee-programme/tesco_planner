class CloudflareEmployerRedirectJob < ApplicationJob
  queue_as :default

  def perform(employer)
    return unless bearer_token && zone_id

    CloudflareForwarding
      .new(bearer_token, zone_id)
      .call(employer)
  end

  private

  def bearer_token
    ENV['CLOUDFLARE_BEARER_TOKEN']
  end

  def zone_id
    ENV['CLOUDFLARE_ZONE_ID']
  end
end
