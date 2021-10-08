module OnboardingEmailsService
  module_function

  def queue_emails_for(user, team)
    create_happi_customer(team)
    OnboardingMailer.welcome(user, team).deliver_later
    # UserMailer.welcome_email(@user).deliver_later(wait: 1.hour)
  end

  def create_happi_customer(team)
    customer = team.customers.create!(
      first_name: "Happi",
      last_name: "Support",
      email: "yo@happi.team",
    )
    customer.avatar.attach(
      io: File.open(icon_path),
      filename: 'happi-icon.png',
      content_type: 'image/png',
      identify: false
    )
  end

  def happi_team
    RootTeam.load
  end

  def icon_path
    Rails.root.join("public", "icon-512.png")
  end
end
