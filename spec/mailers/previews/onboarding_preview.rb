class OnboardingPreview < ActionMailer::Preview
  def welcome
    OnboardingMailer.welcome(user, team)
  end

  def customise_template
    OnboardingMailer.customise_template(user, team)
  end

  def canned_responses
    OnboardingMailer.canned_responses(user, team)
  end

  private

  def user
    User.first
  end

  def team
    user.team
  end
end
