module Ai
  class DetectSpamService < ApplicationService
    option :message
    option :force_thread_update, default: -> { false }

    def call
      # Run spam detection
      agent = SpamDetectAgent.new(message: message, team: team)
      spam_result = agent.perform!

      if spam_result.success?
        spam_score = spam_result.value!

        # Update message with spam score
        message.update(spam_score: spam_score)
        thread.update(spam_score: spam_score) if force_thread_update || thread.spam_score.nil?

        Success(spam_score)
      else
        Failure(spam_result.failure)
      end
    end

    private

    def thread
      message.message_thread
    end

    def team
      thread.team
    end
  end
end
