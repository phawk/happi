module OnboardingEmailsService
  module_function

  def queue_emails_for(user, team)
    # plan = BillingPlan.new(name: team.plan)
    create_happi_customer(team)
    OnboardingMailer.welcome(user, team).deliver_later
    # OnboardingMailer.invite_team(user, team).deliver_later if plan.available_seats > 1
    OnboardingMailer.customise_template(user, team).deliver_later(wait: 5.minutes)
    OnboardingMailer.canned_responses(user, team).deliver_later(wait: 1.day)
  end

  def create_happi_customer(team)
    customer = team.customers.where(email: "yo@happi.team").first_or_initialize
    customer.first_name = "Happi"
    customer.last_name = "Support"
    customer.country_code = "GB"
    customer.location = "UK"
    customer.save!
    customer.avatar.attach(
      io: File.open(icon_path),
      filename: "happi-icon.png",
      content_type: "image/png",
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
