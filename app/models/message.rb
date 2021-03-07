class Message < ApplicationRecord
  belongs_to :message_thread, touch: true
  belongs_to :sender, polymorphic: true

  has_rich_text :content

  def customer?
    sender_type == "Customer"
  end
end
