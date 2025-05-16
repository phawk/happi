class SlackNotifierJob < ApplicationJob
  SLACK_ICON_URL = "https://pete-uploads.s3-eu-west-1.amazonaws.com/happi-slack-Icon.png".freeze

  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(team, message)
    return if team.slack_webhook_url.blank?

    notifier = Slack::Notifier.new(
      team.slack_webhook_url,
      channel: team.slack_channel_name,
      username: "happi-bot",
      icon_url: SLACK_ICON_URL,
    )

    notifier.ping(format_message(message))
  end

  private

  def format_message(message)
    if message.internal?
      [
        "📝 Internal note",
        "From: AI Agent",
        "Subject: #{message.message_thread.subject}\n",
        message.content.to_plain_text,
        "\n<#{view_message_url(message)}|View on Happi>",
      ].join("\n")
    else
      from_name = ActionMailer::Base.email_address_with_name(message.sender.email, message.sender.name)
      [
        "✉️ New message",
        "From: #{from_name}",
        "Subject: #{message.message_thread.subject}\n",
        message.content.to_plain_text,
        "\n<#{view_message_url(message)}|Respond on Happi>",
      ].join("\n")
    end
  end
end
