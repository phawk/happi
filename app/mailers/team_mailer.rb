class TeamMailer < ApplicationMailer
  def new_message(message)
    @message = message
    @thread = message.message_thread
    @team = @thread.team

    emails = @team.users.pluck(:email)

    mail to: emails, subject: t(".subject", from_name: @message.sender.name.familiar)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.team_mailer.not_found.subject
  #
  def not_found(email)
    mail to: email
  end
end
