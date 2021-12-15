require "rails_helper"

RSpec.describe OnboardingEmailsService do
  describe "#queue_emails_for(team)" do
    let(:user) { users(:pete) }
    let(:team) { teams(:acme) }

    before { Current.user = user }

    it "queues onboarding emails to be delivered to their @prioritysupport.net address" do
      perform_enqueued_jobs do
        described_class.queue_emails_for(user, team)
      end

      expect(delivered_emails.size).to eq(4)

      welcome_email = delivered_emails.first
      add_logo_email = delivered_emails[1]
      canned_email = delivered_emails[2]
      everything_else_email = delivered_emails[3]

      expect(welcome_email.subject).to eq("Welcome aboard ACME Corp!")
      expect(welcome_email.to.first).to eq(team.default_mailbox)

      expect(add_logo_email.subject).to eq("Customise your template")
      expect(add_logo_email.to.first).to eq(team.default_mailbox)

      expect(canned_email.subject).to eq("Save time with canned responses")
      expect(canned_email.to.first).to eq(team.default_mailbox)

      expect(everything_else_email.subject).to eq("The last onboarding email...")
      expect(everything_else_email.to.first).to eq(team.default_mailbox)
    end

    it "creates a yo@happi.team customer in their account with the logo" do
      expect do
        described_class.queue_emails_for(user, team)
      end.to change { team.customers.count }.by 1
      happi = team.customers.last
      expect(happi.name).to eq("Happi Support")
      expect(happi.email).to eq("yo@happi.team")
      expect(happi.avatar?).to be(true)
    end
  end
end
