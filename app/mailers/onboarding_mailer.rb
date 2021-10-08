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

  def everything_else(user, team)
    @user = user
    @team = team
    @plan = BillingPlan.new(name: team.plan)
    mail to: team.default_mailbox, subject: "The last onboarding email..."
  end
end
