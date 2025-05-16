require "rails_helper"
require "vcr_helper"

RSpec.describe MessageContextAgent, type: :agent do
  let(:message) { messages(:acme_alex_password_reset_msg_1) }

  subject { described_class.new(team: message.message_thread.team, message: message) }

  describe "#perform!" do
    it "updates the message with the AI context", :vcr do
      resp = subject.perform!
      expect(resp).to be_success
      expect(message.reload.ai_context).to be_present
    end
  end
end
