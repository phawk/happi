class TeamMailer < ApplicationMailer
  def new_message(message)
    @message = message
    @thread = message.message_thread
    @team = @thread.team

    emails = @team.users.pluck(:email)

    mail to: emails, subject: t(".subject", team: @team.name, from_name: @message.sender.name.familiar)
  end

  def not_found(email)
    mail to: email
  end
end
