module Events
  class PostmarkWebhooksController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :authenticate_user!
    skip_before_action :ensure_team!

    def create
      authenticate_or_request_with_http_basic do |username, password|
        username == postmark_username && password == postmark_password
      end

      message_id = params.dig("Metadata", "message_id")

      case params["RecordType"]
      when "Delivery"
        if message_id.present?
          message = Message.find(message_id)
          message.update(status: "delivered")
        end
      when "Bounce"
        if message_id.present?
          message = Message.find(message_id)
          message.update(status: "bounced")
        end
      else
        Rails.logger.debug { "PostmarkWebhooksController: Unhandled type: #{params["RecordType"]}" }
      end
    end

    private

    def postmark_username
      "postmark"
    end

    def postmark_password
      ENV.fetch("POSTMARK_WEBHOOKS_PASSWORD")
    end
  end
end
