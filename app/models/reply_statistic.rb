class ReplyStatistic < ApplicationRecord
  belongs_to :message_thread
  belongs_to :team

  def user
    replies_from_user.first.sender
  end

  def full_content
    "<customer>#{customer_messages_content}</customer>\n\n<user_reply>#{user_replies_content}</user_reply>"
  end

  def customer_messages_content
    messages_from_customer.map { |message| message_content_as_plain_text(message) }.join("\n\n")
  end

  def user_replies_content
    replies_from_user.map { |message| message_content_as_plain_text(message) }.join("\n\n")
  end

  def messages_from_customer
    message_thread.messages.where(id: message_ids.map(&:to_i))
  end

  def replies_from_user
    message_thread.messages.where(id: reply_ids.map(&:to_i))
  end

  private

  def message_content_as_plain_text(message)
    message.content.to_plain_text
  end
end
