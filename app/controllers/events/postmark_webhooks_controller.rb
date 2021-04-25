class Events::PostmarkWebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_team!

  def create
    authenticate_or_request_with_http_basic do |username, password|
      username == 'postmark' && password == 'h4pp1t1m35'
    end

    case params["RecordType"]
    when "Delivery"
      if (message_id = params.dig("Metadata", "message_id"))
        message = Message.find(message_id)
        message.update(status: "delivered")
      end
    else
      puts "PostmarkWebhooksController: Unhandled type: #{params["RecordType"]}"
    end
  end
end
