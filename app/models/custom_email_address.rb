class CustomEmailAddress < ApplicationRecord
  belongs_to :team
  belongs_to :user, optional: true

  validates :email, email: true, presence: true

  def self.matching_team_for(emails:)
    where(email: emails).first&.team
  end
end
