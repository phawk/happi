class OnboardingMailer < ApplicationMailer
  layout "mailers/text_only"

  def welcome(user, team)
    @user = user
    @team = team
    mail to: team.default_mailbox, subject: "Welcome aboard #{team.name}!"
  end

  # def custom_domains
  #   mail to: team.default_mailbox, subject: ""
  # end
end
