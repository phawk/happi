require "rails_helper"

RSpec.describe TeamMailer, type: :mailer do
  describe "new_message" do
    let(:team) { teams(:payhere) }
    let(:message) { messages(:payhere_alex_stripe_msg_1) }
    let(:mail) { described_class.new_message(message) }

    it "renders the headers" do
      expect(mail.subject).to eq("Payhere: New message from Alex S.")
      expect(mail.to).to match_array(team.users.pluck(:email))
    end
  end
end
