require "rails_helper"

RSpec.describe Events::PostmarkWebhooksController, type: :request do
  let(:message) { messages(:payhere_alex_password_reset_msg_1) }
  let(:http_auth) do
    ActionController::HttpAuthentication::Basic.encode_credentials("postmark", "h4pp1t1m35")
  end

  describe "#create" do
    it "marks message as delivered" do
      post "/events/postmark", params: {
        "Metadata" => {
          "message_id" => message.id.to_s,
        },
        "RecordType" => "Delivery",
      }, headers: { "HTTP_AUTHORIZATION" => http_auth }

      message.reload

      expect(response).to have_http_status(:no_content)
      expect(message.status).to eq("delivered")
    end

    it "marks message as bounced" do
      post "/events/postmark", params: {
        "Metadata" => {
          "message_id" => message.id.to_s,
        },
        "RecordType" => "Bounce",
      }, headers: { "HTTP_AUTHORIZATION" => http_auth }

      message.reload

      expect(response).to have_http_status(:no_content)
      expect(message.status).to eq("bounced")
    end

    it "ignores if message ID not found" do
      post "/events/postmark", params: { "RecordType" => "Delivery" }, headers: { "HTTP_AUTHORIZATION" => http_auth }

      expect(response).to have_http_status(:no_content)
    end
  end
end
