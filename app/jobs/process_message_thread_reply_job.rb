class ProcessMessageThreadReplyJob < ApplicationJob
  queue_as :default

  def perform(message_thread)
    result = CalculateReplyStatistics.new(message_thread: message_thread).call

    if result.success?
      # Embed with AI
      reply_statistics = result.value!

      reply_statistics.each do |reply_statistic|
        open_ai_embedding = Ai::EmbeddingService.embed(reply_statistic.full_content)

        Embedding.create!(
          user: reply_statistic.user,
          team: reply_statistic.team,
          object: reply_statistic,
          content: reply_statistic.full_content,
          vectors: open_ai_embedding
        )
      end
    else
      Rails.logger.error("Error calculating reply statistics for thread #{message_thread.id}: #{result.failure}")
    end
  end
end
