require "rails_helper"

RSpec.describe OnboardingMailer, type: :mailer do
  let(:user) { users(:pete) }
  let(:team) { teams(:payhere) }

  describe "welcome" do
    let(:mail) { OnboardingMailer.welcome(user, team) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome aboard Payhere!")
      expect(mail.to).to eq(["payhere@prioritysupport.net"])
      expect(mail.from).to eq(["yo@happi.team"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Thanks for signing up")
    end
  end

  describe "customise_template" do
    let(:mail) { OnboardingMailer.customise_template(user, team) }

    it "renders the headers" do
      expect(mail.subject).to eq("Customise your template")
      expect(mail.to).to eq(["payhere@prioritysupport.net"])
      expect(mail.from).to eq(["yo@happi.team"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("")
    end
  end
end
