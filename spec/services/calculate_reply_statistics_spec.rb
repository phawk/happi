require "rails_helper"

RSpec.describe CalculateReplyStatistics do
  let(:message_thread) { message_threads(:acme_alex_stripe) }

  describe "#call" do
    it "creates a reply statistic" do
      result = described_class.new(message_thread: message_thread).call
      expect(result).to be_success
      expect(result.value!.count).to eq(1)

      stat = result.value!.first
      expect(stat.message_thread).to eq(message_thread)
      expect(stat.first_customer_message).to eq(messages(:acme_alex_stripe_msg_1))
      expect(stat.message_ids).to eq([messages(:acme_alex_stripe_msg_1).id.to_s])
      expect(stat.reply_ids).to eq([messages(:acme_alex_stripe_msg_2).id.to_s])
      expect(stat.time_to_reply).to eq(7405)
    end
  end
end
