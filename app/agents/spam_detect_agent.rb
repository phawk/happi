class SpamDetectAgent < ApplicationAgent
  generate_with :openai, model: "gpt-4o-mini", instructions: "You are a spam detection agent."

  def detect(message:, team:)
    @message = message
    @team = team

    # Call the AI provider to get the spam score using the associated view
    # response = generate(prompt: { message: @message, team: @team })
    prompt do |format|
      format.text { render plain: "Something" }
    end

    binding.irb



    # score = parse_score_from_response(response&.content)

    # # Potentially handle errors from the AI call here (e.g., log if score is nil)
    # Rails.logger.error("SpamDetectAgent failed to get score for message #{message.id}") if score.nil?

    # # Return score or 0.0 if parsing failed
    # score || 0.0
  # rescue StandardError => e
  #   # Log errors during generation
  #   Rails.logger.error("SpamDetectAgent error for message #{message.id}: #{e.message}")
  #   0.0 # Return a safe default score on error
  end

  private

  # Implement logic to parse the score from the AI response
  def parse_score_from_response(response_content)
    return nil if response_content.blank?

    # Attempt to convert the response content directly to a float
    begin
      score = Float(response_content.strip)
      # Clamp the score between 0 and 10
      [[score, 0.0].max, 10.0].min
    rescue ArgumentError, TypeError
      # Log if parsing fails
      Rails.logger.warn("SpamDetectAgent could not parse score from response: #{response_content}")
      nil
    end
  end

  # The prompt content will be rendered from app/views/agents/spam_detect/detect.text.erb
  # Ensure the view is created and contains the necessary instructions for the AI.
end
