class Team < ApplicationRecord
  before_create :generated_mail_hash

  has_secure_token :invite_code
  has_and_belongs_to_many :users
  has_many :customers, dependent: :destroy
  has_many :message_threads, dependent: :destroy
  has_many :custom_email_addresses, dependent: :destroy

  validates :name, presence: true

  def verified?
    verified_at.present?
  end

  def default_mailbox
    "#{mail_hash}@in.happi.team"
  end

  def emails_to_send_from
    custom_email_addresses.confirmed.map(&:to_s) << default_from_address
  end

  def default_from_address
    "#{name} <yo@happi.team>"
  end

  private

  def generated_mail_hash
    loop do
      self.mail_hash = SecureRandom.hex(8)
      break unless Team.find_by(mail_hash: mail_hash)
    end
  end
end
