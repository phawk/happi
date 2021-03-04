class Message < ApplicationRecord
  belongs_to :message_thread
  belongs_to :sender, polymorphic: true
end
