class Message < ApplicationRecord
  STATUS = %w[received pending delivered bounced].freeze

  after_create_commit { broadcast_append_to(turbo_channel, target: "messages") }
  after_update_commit { broadcast_replace_to(turbo_channel) }
  after_destroy_commit { broadcast_remove_to(turbo_channel) }

  belongs_to :message_thread, touch: true
  belongs_to :sender, polymorphic: true

  has_rich_text :content

  validates :content, presence: true, if: :user?

  def customer?
    sender_type == "Customer"
  end

  def user?
    sender_type == "User"
  end

  def deliver_email_via
    from_address.presence || message_thread.team.default_from_address
  end

  def turbo_channel
    "thread_#{message_thread_id}_messages"
  end
end
