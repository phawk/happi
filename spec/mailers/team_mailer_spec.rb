require "rails_helper"

RSpec.describe TeamMailer, type: :mailer do
  describe "new_message" do
    let(:team) { teams(:acme) }
    let(:message) { messages(:acme_alex_stripe_msg_1) }
    let(:mail) { described_class.new_message(message) }

    it "renders the headers" do
      expect(mail.subject).to eq("ACME Corp: New message from Alex S.")
      expect(mail.to).to match_array(team.users.pluck(:email))
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("You just received a message from")
    end
  end

  describe "verified" do
    let(:team) { teams(:acme) }
    let(:mail) { described_class.verified(team) }

    it "renders the headers" do
      expect(mail.subject).to eq("Your account has been verified")
      expect(mail.to).to match_array(team.users.pluck(:email))
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("verified")
    end
  end

  describe "email_awaiting_approval" do
    let(:team) { teams(:acme) }
    let(:custom_email_address) { "help@acme.com" }
    let(:mail) { described_class.email_awaiting_approval(team, custom_email_address) }

    it "renders the headers" do
      expect(mail.subject).to eq("Your custom email is awaiting approval")
      expect(mail.to).to match_array(team.users.pluck(:email))
    end

    it "renders the body" do
      expect(mail.body.encoded).to include(custom_email_address)
    end
  end
end
