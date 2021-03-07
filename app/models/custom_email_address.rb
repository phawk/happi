class CustomEmailAddress < ApplicationRecord
  belongs_to :team
  belongs_to :user, optional: true

  validates :email, email: true, presence: true

  def self.matching_emails(emails)
    where(email: emails).where.not(confirmed_at: nil).first
  end
end
