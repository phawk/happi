class OnboardingPreview < ActionMailer::Preview
  def welcome
    user = User.first
    OnboardingMailer.welcome(user, user.team)
  end

  def customise_template
    user = User.first
    OnboardingMailer.customise_template(user, user.team)
  end
end
