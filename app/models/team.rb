class Team < ApplicationRecord
  SUBSCRIPTION_STATES = %w[pending incomplete incomplete_expired trialing active past_due canceled unpaid].freeze
  ACTIVE_SUBSCRIPTION_STATES = %w[trialing active past_due].freeze

  before_create :generated_mail_hash
  before_destroy :unset_user_teams

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
  validates :subscription_status, presence: true, inclusion: { in: SUBSCRIPTION_STATES }

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
    ActionMailer::Base.email_address_with_name("yo@happi.team", name)
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

  private

  def generated_mail_hash
    loop do
      self.mail_hash = SecureRandom.hex(8)
      break unless Team.find_by(mail_hash: mail_hash)
    end
  end
end
