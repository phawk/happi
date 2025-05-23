module ImageUploads
  class LogoController < ApplicationController
    skip_before_action :authenticate_user!

    def show
      message = GlobalID::Locator.locate(params[:id], only: Message)
      return head :not_found unless message.present?
      logo = message.message_thread.team.logo

      if logo.attached?
        track_open(message)
        response.headers["Content-Type"] = logo.content_type
        response.headers["Content-Disposition"] = "inline; #{logo.filename.to_s.parameterize}"

        # redirect_to rails_storage_proxy_path(lead_message.team.logo)
        logo.download do |chunk|
          response.stream.write(chunk)
        end
      else
        head :not_found
      end
    end

    private

    def track_open(message)
      message.update!(status: "opened")

      MessageStatusUpdate.create!(
        message: message,
        value: "open",
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      )
    end
  end
end
