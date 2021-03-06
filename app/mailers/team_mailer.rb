class TeamMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.team_mailer.not_found.subject
  #
  def not_found(email)
    mail to: email
  end
end
