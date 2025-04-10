class ProcessNewMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    NotificationService.new_message(message.message_thread.team, message)
  end
end
