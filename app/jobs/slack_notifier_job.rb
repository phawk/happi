class SlackNotifierJob < ApplicationJob
  queue_as :default

  def perform(team, message)
    return if team.slack_webhook_url.blank?

    notifier = Slack::Notifier.new(
      team.slack_webhook_url,
      channel: team.slack_channel_name,
      username: "happi-bot",
    )

    notifier.ping(format_message(message))
  end

  private

  def format_message(message)
    [
      "**New message**",
      "From: #{message.sender.name} <#{message.sender.email}>",
      "Subject: #{message.message_thread.subject}",
      message.content.to_plain_text
    ].join("\n")
  end
end
