class ProcessMessageThreadReplyJob < ApplicationJob
  queue_as :default

  def perform(message_thread)
    result = CalculateReplyStatistics.new(message_thread: message_thread).call

    if result.success?
      # Embed with AI
      reply_statistic = result.value!
      open_ai_embedding = Ai::EmbeddingService.embed(reply_statistic.full_content)

      Embedding.create!(
        user: reply_statistic.user,
        team: reply_statistic.team,
        object: reply_statistic,
        content: reply_statistic.full_content,
        vectors: open_ai_embedding
      )
    end
  end
end
