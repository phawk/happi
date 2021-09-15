require "rails_helper"

RSpec.describe StripeWebhooks::SubscriptionDeleted do
  let(:team) { teams(:payhere) }
  before { StripeMock.start }
  after { StripeMock.stop }

  it "updates subscription state" do
    event =
      StripeMock.mock_webhook_event(
        "customer.subscription.deleted"
      )
    stripe_sub = event[:data][:object]
    stripe_sub[:metadata] = {
      "happi_team_id" => team.id
    }

    subject.call(event)

    expect(team.reload.subscription_status).to eq("canceled")
  end
end
