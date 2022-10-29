class TeamUser < ApplicationRecord
  ROLES = %w[member owner].freeze
  self.table_name = "teams_users"

  belongs_to :team
  belongs_to :user

  def self.users
    User.where(id: pluck(:user_id))
  end

  def owner?
    role == "owner"
  end
end
