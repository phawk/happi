require "rails_helper"

RSpec.describe ReplyStatistic, type: :model do
  let(:reply_statistic) do
    ReplyStatistic.create!(
      message_thread: message_threads(:acme_alex_stripe),
      message_ids: [messages(:acme_alex_stripe_msg_1).id],
      reply_ids: [messages(:acme_alex_stripe_msg_2).id],
      time_to_reply: 7436,
      team: teams(:acme)
    )
  end

  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:message_thread) }

  describe "#customer_messages_content" do
    it "returns the content of the messages" do
      expect(reply_statistic.customer_messages_content).to eq("I need to reset my stripe connection, can you help?")
    end
  end

  describe "#user_replies_content" do
    it "returns the content of the messages" do
      expect(reply_statistic.user_replies_content).to eq("No probs, your Stripe account has been disconnected, you can now connect a new one!")
    end
  end
end
