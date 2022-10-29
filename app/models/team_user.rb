class TeamUser < ApplicationRecord
  ROLES = %w[member owner].freeze
  self.table_name = "teams_users"

  belongs_to :team
  belongs_to :user
end
