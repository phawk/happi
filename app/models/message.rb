class Message < ApplicationRecord
  belongs_to :message_thread
  belongs_to :sender, polymorphic: true

  def customer?
    sender_type == "Customer"
  end
end
