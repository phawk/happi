require "rails_helper"

RSpec.describe Message, type: :model do
  it { is_expected.to belong_to(:message_thread) }
  it { is_expected.to belong_to(:sender) }

  describe ".search" do
    it "searches message content" do
      results = described_class.search("Stripe account has been disconnected")
      expect(results).to contain_exactly(messages(:acme_alex_stripe_msg_2))
    end

    it "returns empty when there are no results" do
      results = described_class.search("notfoundhere")
      expect(results).to be_empty
    end
  end
end
