module RootTeam
  module_function

  def load
    Team.find(ENV.fetch("HAPPI_TEAM_ID"))
  end
end
