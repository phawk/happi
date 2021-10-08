module OnboardingEmailsService
  module_function

  def queue_emails_for(user, team)
    OnboardingMailer.welcome(user, team).deliver_later
    # UserMailer.welcome_email(@user).deliver_later(wait: 1.hour)
  end

  private

  def happi_team
    RootTeam.load
  end
end
