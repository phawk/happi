require "rails_helper"

FakeNotifier = Struct.new(:message) do
  def ping(message)
    self.message = message
  end
end

RSpec.describe SlackNotifierJob, type: :job do
  let(:team) { teams(:acme) }
  let(:message) { messages(:acme_alex_password_reset_msg_1) }

  it "does nothing when team has no slack webhooks URL" do
    subject.perform(team, message)
  end

  it "sends slack messages" do
    fake_notifier = FakeNotifier.new
    allow(Slack::Notifier).to receive(:new).with(
      "https://example.com/123",
      channel: "#support",
      username: "happi-bot",
      icon_url: SlackNotifierJob::SLACK_ICON_URL,
    ).and_return(fake_notifier)

    team.update(slack_webhook_url: "https://example.com/123", slack_channel_name: "#support")
    subject.perform(team, message)

    expect(fake_notifier.message).to eq([
      "**New message**",
      "From: Pete Hawkins <petey@hey.com>",
      "Subject: Help resetting my password\n",
      "Hello Alex, I have reset your password, please try logging in again now.",
      "\n<http://happi.test/view_message/#{message.id}|Respond on Happi>",
    ].join("\n"))
  end
end
