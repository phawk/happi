require "rails_helper"

RSpec.describe CustomerMailer, type: :mailer do
  describe "new_reply" do
    let(:message) { messages(:payhere_alex_stripe_msg_2) }
    let(:mail) { CustomerMailer.new_reply(message) }

    it "renders the headers" do
      expect(mail.subject).to eq(message.message_thread.subject)
      expect(mail.to).to eq([message.message_thread.customer.email])
      expect(mail.from).to eq(["yo@happi.team"])
    end

    it "renders the body" do
      message_content = "No probs, your Stripe account has been disconnected, you can now connect a new one!"

      expect(mail.html_part.to_s).to include(message_content)
      expect(mail.text_part.to_s).to include(message_content)
    end
  end
end
