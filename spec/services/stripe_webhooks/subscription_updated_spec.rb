require "rails_helper"

RSpec.describe StripeWebhooks::SubscriptionUpdated do
  let(:team) { teams(:acme) }

  before { StripeMock.start }

  after { StripeMock.stop }

  it "updates subscription state" do
    event =
      StripeMock.mock_webhook_event(
        "customer.subscription.updated"
      )
    stripe_sub = event[:data][:object]
    stripe_sub[:metadata] = {
      "happi_team_id" => team.id,
    }

    subject.call(event)

    expect(team.reload.subscription_status).to eq("active")
    expect(team.reload.stripe_subscription_id).to eq(stripe_sub.id)
  end
end
