require "rails_helper"

RSpec.describe OnboardingEmailsService do
  describe "#queue_emails_for(team)" do
    let(:user) { users(:pete) }
    let(:team) { teams(:payhere) }

    it "queues onboarding emails to be delivered to their @prioritysupport.net address" do
      perform_enqueued_jobs do
        described_class.queue_emails_for(user, team)
      end

      expect(delivered_emails.size).to eq(1)
      expect(delivered_emails.first.subject).to eq("Welcome aboard Payhere!")
      expect(delivered_emails.first.to.first).to eq(team.default_mailbox)
    end
  end
end
