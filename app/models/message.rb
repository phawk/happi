class Message < ApplicationRecord
  STATUS = %w[received pending delivered bounced].freeze
  include PgSearch::Model

  after_create_commit { broadcast_append_to(turbo_channel, target: "messages") }
  after_update_commit { broadcast_replace_to(turbo_channel) }
  after_destroy_commit { broadcast_remove_to(turbo_channel) }

  has_rich_text :content

  pg_search_scope :search,
    associated_against: {
      rich_text_content: [:body],
    },
    using: { tsearch: { prefix: true, dictionary: "english" } }

  belongs_to :message_thread, touch: true
  belongs_to :sender, polymorphic: true

  scope :internal, -> { where(internal: true) }
  scope :customer_facing, -> { where(internal: false) }

  validates :content, presence: true, if: :user?

  def customer?
    sender_type == "Customer"
  end

  def user?
    sender_type == "User"
  end

  def ai?
    sender_type == "Team" && ai_agent?
  end

  def deliver_email_via
    from_address.presence || message_thread.team.default_from_address
  end

  def turbo_channel
    "thread_#{message_thread_id}_messages"
  end

  def action_mailbox_record
    ActionMailbox::InboundEmail.find(action_mailbox_id) if action_mailbox_id.present?
  end
end
