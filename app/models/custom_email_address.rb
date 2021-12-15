class CustomEmailAddress < ApplicationRecord
  include TeamOwnable
  belongs_to :user, optional: true

  validates :email, email: true, presence: true

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def self.matching_emails(emails)
    where(email: emails).confirmed.first
  end

  def to_s
    if from_name.present?
      "#{from_name} <#{email}>"
    else
      email
    end
  end
end
