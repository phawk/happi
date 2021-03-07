class Team < ApplicationRecord
  before_create :generated_mail_hash

  has_and_belongs_to_many :users
  has_many :customers, dependent: :destroy
  has_many :message_threads, dependent: :destroy
  has_many :custom_email_addresses, dependent: :destroy

  validates :name, presence: true

  private

  def generated_mail_hash
    loop do
      self.mail_hash = SecureRandom.hex(8)
      break unless Team.find_by(mail_hash: mail_hash)
    end
  end
end
