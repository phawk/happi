require "rails_helper"

RSpec.describe OnboardingMailer, type: :mailer do
  let(:user) { users(:pete) }
  let(:team) { teams(:acme) }

  describe "welcome" do
    let(:mail) { OnboardingMailer.welcome(user, team) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome aboard ACME Corp!")
      expect(mail.to).to eq(["acme@prioritysupport.net"])
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
      expect(mail.to).to eq(["acme@prioritysupport.net"])
      expect(mail.from).to eq(["yo@happi.team"])
    end
  end

  describe "canned_responses" do
    let(:mail) { OnboardingMailer.canned_responses(user, team) }

    it "renders the headers" do
      expect(mail.subject).to eq("Save time with canned responses")
      expect(mail.to).to eq(["acme@prioritysupport.net"])
      expect(mail.from).to eq(["yo@happi.team"])
    end
  end

  describe "everything_else" do
    let(:mail) { OnboardingMailer.everything_else(user, team) }

    it "renders the headers" do
      expect(mail.subject).to eq("The last onboarding email...")
      expect(mail.to).to eq(["acme@prioritysupport.net"])
      expect(mail.from).to eq(["yo@happi.team"])
    end
  end
end
