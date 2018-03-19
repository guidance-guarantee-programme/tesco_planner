module Mailgun
  class DropsController < ActionController::Base
    def create
      @activity = DropForm.new(drop_params).create_activity
      PusherNotificationJob.perform_later(@activity) if @activity

      head :ok
    end

    private

    def drop_params
      params.permit(
        :event,
        :description,
        :appointment_id,
        :message_type,
        :environment,
        :timestamp,
        :token,
        :signature
      )
    end
  end
end
