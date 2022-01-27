class TeamMailer < ApplicationMailer
  def new_message(message)
    @message = message
    @thread = message.message_thread
    @team = @thread.team

    emails = @team.users.pluck(:email)

    mail to: emails, subject: t(".subject", team: @team.name, from_name: @message.sender.name.familiar)
  end

  def verified(team)
    @team = team

    emails = team.users.pluck(:email)

    mail to: emails, subject: t(".subject")
  end

  def not_found(email)
    mail to: email
  end

  def email_awaiting_approval(team, custom_email_address)
    @team = team
    @custom_email_address = custom_email_address

    mail to: team.users.pluck(:email), subject: t(".subject")
  end
end
