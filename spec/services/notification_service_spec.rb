require "rails_helper"

RSpec.describe NotificationService do
  let(:team) { teams(:acme) }
  let(:message) { messages(:acme_alex_stripe_msg_1) }

  describe "#new_message(team, message)" do
    it "sends a new message email notification" do
      perform_enqueued_jobs do
        described_class.new_message(team, message)
        expect(last_email.subject).to eq("ACME Corp: New message from Alex S.")
        expect(last_email.to).to include("petey@hey.com")
      end
    end

    it "doesnt send notification when all users has notifications disabled" do
      perform_enqueued_jobs do
        team.team_users.update_all(message_notifications: false)
        described_class.new_message(team, message)
        expect(delivered_emails.size).to be_zero
      end
    end

    it "queues SlackNotifierJob if the team has slack enabled" do
      teams(:acme).update!(slack_channel_name: "#support", slack_webhook_url: "https://example.org")

      perform_enqueued_jobs(except: SlackNotifierJob) do
        described_class.new_message(team, message)
        expect(SlackNotifierJob).to have_been_enqueued
      end
    end
  end
end
