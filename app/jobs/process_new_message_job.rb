class ProcessNewMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    team = message.message_thread.team
    spam_score = 0.0

    result = Ai::DetectSpamService.new(message: message).call

    if result.success?
      spam_score = result.value!
    else
      Rails.logger.error("Error detecting spam for message #{message.id}: #{result.failure}")
    end

    # Only send notifications if the message is below the team's spam threshold
    if message.message_thread.reload.spam_score < team.spam_threshold
      NotificationService.new_message(team, message)

      MessageContextAgent.new(
        team: team,
        message: message
      ).perform_async!
    else
      Rails.logger.info("Message #{message.id} detected as spam (score: #{spam_score}), skipping notification.")
    end
  rescue StandardError => e
    # Log errors during job execution
    Rails.logger.error("ProcessNewMessageJob failed for message #{message.id}: #{e.message}")
    # Optionally re-raise or handle specific errors
  end
end
