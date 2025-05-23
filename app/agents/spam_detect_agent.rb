class SpamDetectAgent < ApplicationAgent
  INSTRUCTIONS = <<~INSTRUCTIONS
    You are a spam detection agent.
    Determine if this email is genuine customer support request or if it is spam, unsolicited sales pitch (especially for development services), or other non-support related communication.
    Spam includes unsolicited emails like automated replies (or out of office), marketing emails, survey requests, sales pitches, etc.

    After making your analysis, return ONLY a numerical score between 0 and 10 (no other text or comments) – where 0 means it is definitely a genuine support request and 10 means it is definitely spam/unsolicited.
  INSTRUCTIONS

  option :message

  def perform!
    prompt = <<~PROMPT
      Analyze the following email content:
      <message>
        #{message.content.to_plain_text}
      </message>

      #{team.spam_prompt}
    PROMPT

    prompt_message = Ai::Agent::Message.new(
      role: "user",
      content: prompt
    )

    response = generate!(instructions: INSTRUCTIONS, messages: [
      prompt_message
    ])

    score = parse_score_from_response(response&.content)

    # Potentially handle errors from the AI call here (e.g., log if score is nil)
    if score.nil?
      Failure("SpamDetectAgent failed to get score for message #{message.id}")
    else
      Success(score)
    end
  rescue StandardError => e
    Failure("SpamDetectAgent error for message #{message.id}: #{e.message}")
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
