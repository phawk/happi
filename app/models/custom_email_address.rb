class CustomEmailAddress < ApplicationRecord
  belongs_to :team
  belongs_to :user, optional: true

  validates :email, email: true, presence: true

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def self.matching_emails(emails)
    where(email: emails).confirmed.first
  end

  def to_s
    if from_name.present?
      ActionMailer::Base.email_address_with_name(email, from_name)
    else
      email
    end
  end
end
