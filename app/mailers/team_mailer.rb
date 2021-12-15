class TeamMailer < ApplicationMailer
  def new_message(message, team)
    Current.team = team

    @message = message
    @thread = message.message_thread
    @team = team

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
end
