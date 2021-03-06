require "rails_helper"

RSpec.describe TeamMailer, type: :mailer do
  describe "not_found" do
    let(:mail) { TeamMailer.not_found }

    it "renders the headers" do
      expect(mail.subject).to eq("Not found")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
