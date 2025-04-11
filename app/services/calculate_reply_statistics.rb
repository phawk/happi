class CalculateReplyStatistics < ApplicationService
  option :message_thread

  def call
    messages = message_thread.messages.customer_facing.order(:created_at).pluck(:id, :sender_type, :created_at)
    blocks = []
    current_block = { customer: [], user: [] }

    messages.each do |msg|
      if msg[1] == "Customer"
        if current_block[:user].any?
          blocks << current_block
          current_block = { customer: [], user: [] }
        end
        current_block[:customer] << msg
      elsif msg[1] == "User"
        current_block[:user] << msg
      end
    end
    blocks << current_block if current_block[:user].any?

    created_reply_statistics = []

    blocks.each do |block|
      # Ensure the block is valid
      if block[:customer].empty? || block[:user].empty?
        next
      end

      first_customer_message_id = block[:customer].first[0]
      reply_statistic = ReplyStatistic.find_or_initialize_by(
        team: message_thread.team,
        message_thread: message_thread,
        first_customer_message_id: first_customer_message_id
      )

      reply_statistic.message_ids = block[:customer].map(&:first)
      reply_statistic.reply_ids = block[:user].map(&:first)
      reply_statistic.time_to_reply = (block[:user].first[2] - block[:customer].last[2]).to_i

      reply_statistic.save!
      created_reply_statistics << reply_statistic
    end

    Success(created_reply_statistics)
  rescue => e
    Failure(e)
  end
end
