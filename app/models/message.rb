class Message < ApplicationRecord
  STATUS = %w[received pending delivered].freeze

  belongs_to :message_thread, touch: true
  belongs_to :sender, polymorphic: true

  has_rich_text :content

  def customer?
    sender_type == "Customer"
  end

  def deliver_email_via
    from_address.presence || message_thread.team.default_from_address
  end
end
