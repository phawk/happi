module SyncUserToHappi
  module_function

  def sync(user)
    happi = RootTeam.load
    team = user.team || user.teams.first
    customer = Customer.where(email: team.default_mailbox).first_or_initialize
    customer.update!(
      team: happi,
      first_name: user.first_name,
      last_name: user.last_name,
      company: user.team&.name
    )
    customer
  end
end
