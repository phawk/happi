require "rails_helper"

RSpec.describe Api::MessagesController, type: :request do
  let(:team) { teams(:acme) }
  let(:alex) { customers(:acme_alex) }

  describe "POST /api/:key/messages" do
    it "creates a new message when customer JWT is valid" do
      teams(:acme).update!(slack_channel_name: "#support", slack_webhook_url: "https://example.org")

      expect(NotificationService).to receive(:new_message).with(team, an_instance_of(Message))

      perform_enqueued_jobs do
        expect do
          post "/api/#{team.publishable_key}/messages", params: {
            content: "Hello there, I need assistance please.",
            customer_jwt: alex.as_jwt,
          }
        end.to change(Message, :count).by(1)

        expect(response).to have_http_status(:no_content)
        expect(Message.last.channel).to eq("widget")
      end
    end

    it "returns an error when customer JWT is invalid" do
      jwt = JWT.encode({ first_name: "Pedro", last_name: "Gonzalles", email: "pedro@hey.com" }, "bad-secret", "HS512")

      post "/api/#{team.publishable_key}/messages", params: {
        content: "Hello there, I need assistance please.",
        customer_jwt: jwt,
      }

      expect(response).to have_http_status(:bad_request)

      expect(json[:error]).to eq("Invalid JWT for customer")
    end
  end
end
