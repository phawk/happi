class Events::PostmarkWebhooksController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :authenticate_user!
  skip_before_action :ensure_team!

  def create
    authenticate_or_request_with_http_basic do |username, password|
      username == 'postmark' && password == 'h4pp1t1m35'
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
      puts "PostmarkWebhooksController: Unhandled type: #{params["RecordType"]}"
    end
  end
end
