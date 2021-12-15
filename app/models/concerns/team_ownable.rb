module TeamOwnable
  extend ActiveSupport::Concern

  included do
    # Team is actually not optional, but we not do want
    # to generate a SELECT query to verify the team is
    # there every time. We get this protection for free
    # because of the `Current.team_or_raise!`
    # and also through FK constraints.
    belongs_to :team, optional: true
    default_scope { where(team: Current.team_or_raise!) }
  end
end
