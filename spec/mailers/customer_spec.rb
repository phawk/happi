require "rails_helper"

RSpec.describe CustomerMailer, type: :mailer do
  describe "new_reply" do
    let(:message) { Message.first! }
    let(:mail) { CustomerMailer.new_reply(message) }

    it "renders the headers" do
      expect(mail.subject).to eq(message.message_thread.subject)
      expect(mail.to).to eq([message.message_thread.customer.email])
      # expect(mail.from).to eq(["from@example.com"])
    end
  end
end
