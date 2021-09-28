module SyncUserToHappi
  module_function

  def sync(user)
    happi = Team.find(ENV.fetch("HAPPI_TEAM_ID"))
    customer = Customer.where(email: user.email).first_or_initialize
    customer.update!(
      team: happi,
      first_name: user.first_name,
      last_name: user.last_name,
      company: user.team&.name
    )
    customer
  end
end
