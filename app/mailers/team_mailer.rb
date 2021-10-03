class TeamMailer < ApplicationMailer
  def welcome(team)
    @team = team
    @team.users.find_each do |user|
      @user = user
      email = user.email
      mail to: email, subject: t(".subject", team: @team.name)
    end
  end

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
end
