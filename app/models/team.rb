class Team < ApplicationRecord
  include AttrJson::Record

  ACCESS_LEVELS = %w[standard internal]
  SUBSCRIPTION_STATES = %w[pending incomplete incomplete_expired trialing active past_due canceled unpaid].freeze
  ACTIVE_SUBSCRIPTION_STATES = %w[trialing active past_due].freeze

  before_destroy :unset_user_teams

  attr_json :sent_verified_email, :boolean

  has_one_attached :logo do |blob|
    blob.variant :small, resize_to_fit: [600, 100]
    blob.variant :medium, resize_to_fit: [800, 160]
  end

  has_secure_token :invite_code
  has_secure_token :publishable_key
  has_secure_token :shared_secret
  has_many :team_users, dependent: :destroy
  has_many :users, through: :team_users
  has_many :customers, dependent: :destroy
  has_many :message_threads, dependent: :destroy
  has_many :blocked_domains, dependent: :destroy
  has_many :custom_email_addresses, dependent: :destroy
  has_many :canned_responses, dependent: :destroy
  has_many :file_uploads, class_name: 'KnowledgeBase::FileUpload', dependent: :destroy

  validates :name, presence: true
  validates :mail_hash, email_name: true, presence: true, uniqueness: true
  validates :plan, inclusion: { in: BillingPlan::PLANS }
  validates :subscription_status, presence: true, inclusion: { in: SUBSCRIPTION_STATES }

  def internal_access?
    access_level == "internal"
  end

  def allowed_threads
    message_threads.where.not(customer_id: customers.blocked.select(:id))
  end

  def blocked_threads
    message_threads.where(customer_id: customers.blocked.select(:id))
  end

  def messages
    Message.where(message_thread_id: allowed_threads.select(:id))
  end

  def add_user(user, set_active_team: false, role: "member")
    unless team_users.where(user_id: user.id).count.positive?
      team_users.create!(user: user, role: role)
    end

    if set_active_team
      user.update(team: self)
    end
  end

  def users_for_email(email_type)
    case email_type
    when :message_notification
      team_users.where(message_notifications: true).users
    else
      User.none
    end
  end

  def verified?
    verified_at.present?
  end

  def default_mailbox
    "#{mail_hash}@prioritysupport.net"
  end

  def emails_to_send_from
    custom_email_addresses.confirmed.map(&:to_s) << default_from_address
  end

  def default_from_address
    ActionMailer::Base.email_address_with_name(default_mailbox, name)
  end

  def has_logo?
    logo.attached?
  end

  def has_available_seat?
    users.count < available_seats
  end

  def messages_used_this_month
    Message \
      .where("created_at >= ?", Time.zone.now.beginning_of_month)
      .where(message_thread_id: message_threads.pluck(:id))
      .count
  end

  def messages_sent
    Message \
      .where(sender_type: "User")
      .where(message_thread_id: message_threads.pluck(:id))
      .count
  end

  def messages_limit_reached?
    messages_used_this_month >= messages_limit
  end

  def change_plan(plan)
    update!(
      plan: plan.id,
      messages_limit: plan.messages_limit,
      available_seats: plan.available_seats,
      subscription_status: plan.initial_subscription_state,
    )
  end

  def can_send_messages?
    return false unless verified?
    return false unless subscription_active?
    return false if messages_limit_reached?
    true
  end

  def subscription_active?
    subscription_status.in?(ACTIVE_SUBSCRIPTION_STATES)
  end

  def unset_user_teams
    User.where(team_id: id).update_all(team_id: nil) # rubocop:disable Rails/SkipsModelValidations
  end

  def slack_integration?
    slack_webhook_url.present? && slack_channel_name.present?
  end

  private

  def generated_mail_hash
    loop do
      self.mail_hash = SecureRandom.hex(8)
      break unless Team.find_by(mail_hash: mail_hash)
    end
  end
end
