class OnboardingPreview < ActionMailer::Preview
  def welcome
    user = User.first
    OnboardingMailer.welcome(user, user.team)
  end

  # def custom_domains
  #   OnboardingMailer.custom_domains
  # end
end
