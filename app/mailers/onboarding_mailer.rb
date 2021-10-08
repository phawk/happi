class OnboardingMailer < ApplicationMailer
  layout "mailers/simple"

  def welcome(user, team)
    @user = user
    @team = team
    mail to: team.default_mailbox, subject: "Welcome aboard #{team.name}!"
  end

  def customise_template(user, team)
    @user = user
    @team = team
    mail to: team.default_mailbox, subject: "Customise your template"
  end

  def canned_responses(user, team)
    @user = user
    @team = team
    mail to: team.default_mailbox, subject: "Save time with canned responses"
  end
end
