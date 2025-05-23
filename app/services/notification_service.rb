module NotificationService
  module_function

  def new_message(team, message)
    if team.users_for_email(:message_notification).count.positive?
      TeamMailer.new_message(message).deliver_later
    end

    if team.slack_integration?
      SlackNotifierJob.perform_later(team, message)
    end
  end

  def new_internal_note(team, message)
    if team.users_for_email(:message_notification).count.positive?
      TeamMailer.new_internal_note(message).deliver_later
    end

    if team.slack_integration?
      SlackNotifierJob.perform_later(team, message)
    end
  end
end
