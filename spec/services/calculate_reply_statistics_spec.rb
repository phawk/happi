require "rails_helper"

RSpec.describe CalculateReplyStatistics do
  let(:message_thread) { message_threads(:acme_alex_stripe) }

  describe "#call" do
    it "creates a reply statistic" do
      expect do
        result = described_class.new(message_thread: message_thread).call
        expect(result).to be_success
      end.to change(ReplyStatistic, :count).by(1)
    end
  end
end
