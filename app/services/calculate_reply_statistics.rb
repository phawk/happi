class CalculateReplyStatistics < ApplicationService
  option :message_thread

  def call
    messages = message_thread.messages.order(created_at: :desc).pluck(:id, :sender_type, :created_at)
    last_customer_messages = []
    last_user_messages = []

    # Find the last block of customer messages
    messages.each do |msg|
      if msg[1] == "Customer"
        last_customer_messages.unshift(msg)
      elsif !last_customer_messages.empty?
        break
      end
    end

    # Find the last block of user messages immediately following the last customer message
    messages.each do |msg|
      if msg[1] == "User"
        last_user_messages.unshift(msg)
      elsif !last_user_messages.empty?
        break
      end
    end

    time_to_reply = (last_user_messages.first[2] - last_customer_messages.last[2]).to_i

    reply_statistic = ReplyStatistic.create!(
      message_thread: message_thread,
      message_ids: last_customer_messages.map(&:first),
      reply_ids: last_user_messages.map(&:first),
      team: message_thread.team,
      time_to_reply: time_to_reply
    )

    Success(reply_statistic)
  rescue => e
    Failure(e)
  end
end
