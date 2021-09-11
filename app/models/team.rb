class Team < ApplicationRecord
  before_create :generated_mail_hash

  has_one_attached :logo
  has_secure_token :invite_code
  has_secure_token :publishable_key
  has_secure_token :shared_secret
  has_and_belongs_to_many :users
  has_many :customers, dependent: :destroy
  has_many :message_threads, dependent: :destroy
  has_many :custom_email_addresses, dependent: :destroy
  has_many :canned_responses, dependent: :destroy

  validates :name, presence: true
  validates :plan, inclusion: { in: BillingPlan::PLANS }

  def allowed_threads
    message_threads.where.not(customer_id: customers.blocked.pluck(:id))
  end

  def add_user(user, set_active_team: false)
    users << user unless users.exists?(user.id)
    if set_active_team
      user.update(team: self)
    end
  end

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

  def has_logo?
    logo.attached?
  end

  def has_available_seat?
    users.count < available_seats
  end

  def messages_used_this_month
    Message \
      .where("created_at >= ?", Time.now.beginning_of_month)
      .where(message_thread_id: message_threads.pluck(:id))
      .count
  end

  private

  def generated_mail_hash
    loop do
      self.mail_hash = SecureRandom.hex(8)
      break unless Team.find_by(mail_hash: mail_hash)
    end
  end
end
