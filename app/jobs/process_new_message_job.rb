class ProcessNewMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    team = message.message_thread.team

    # Run spam detection
    agent = SpamDetectAgent.new(message: message, team: team)
    spam_result = agent.perform!
    spam_score = 0.0
    if spam_result.success?
      spam_score = spam_result.value!
      # Update message with spam score
      message.update(spam_score: spam_score)
      message.message_thread.update(spam_score: spam_score) if message.message_thread.spam_score.nil?
    end

    # Only send notifications if the message is below the team's spam threshold
    if message.message_thread.reload.spam_score < team.spam_threshold
      NotificationService.new_message(team, message)
    else
      Rails.logger.info("Message #{message.id} detected as spam (score: #{spam_score}), skipping notification.")
    end
  rescue StandardError => e
    # Log errors during job execution
    Rails.logger.error("ProcessNewMessageJob failed for message #{message.id}: #{e.message}")
    # Optionally re-raise or handle specific errors
  end
end
