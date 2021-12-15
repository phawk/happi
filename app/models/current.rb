class Current < ActiveSupport::CurrentAttributes
  attribute :team, :user

  # resets { Time.zone = nil }

  class MissingCurrentTeam < StandardError; end

  def team_or_raise!
    raise Current::MissingCurrentTeam, "You must set a team with Current.team=" unless team

    team
  end

  def user=(user)
    super
    self.team      = user.team
    # Time.zone      = user.time_zone
  end
end
