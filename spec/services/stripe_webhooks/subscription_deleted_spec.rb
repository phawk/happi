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
    team.update!(stripe_subscription_id: stripe_sub.id)

    subject.call(event)

    expect(team.reload.subscription_status).to eq("canceled")
  end
end
