require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  describe "notification" do
    let(:mail) { AdminMailer.notification("New beta signup", "test@hey.com just signed up for the beta") }

    it "renders the headers" do
      expect(mail.subject).to eq("Admin alert: New beta signup")
      expect(mail.to).to eq(["petey@hey.com"])
      expect(mail.from).to eq(["yo@happi.team"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("New beta signup")
      expect(mail.body.encoded).to include("test@hey.com just signed up for the beta")
    end
  end
end
