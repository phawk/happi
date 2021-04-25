class Events::PostmarkWebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_team!

  def create
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
