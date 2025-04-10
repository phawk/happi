class ReplyWriterAgent < ApplicationAgent
  INSTRUCTIONS = <<~INSTRUCTIONS
    You are a reply writer agent.

    You will be given a thread of emails.
    You will need to write a reply to the customer's last email in the thread.

    You have access to a knowledge base of information about our business, products, and services.

    You will use the knowledge base to help you write a reply to the customer's last email.

    Respond with some simple HTML markup to format your reply. Use the following tags:

    <p>
      Hi [Customer Name],
    </p>
    <p>
      This is your reply to the customer's last email.
    </p>
    <p>
      Thanks,
      [User's First Name] - [User's company name]
    </p>

  INSTRUCTIONS

  option :thread
  option :current_user

  def perform!
    prompt = []
    prompt << "<replying_user>"
    prompt << "#{current_user.name} <#{current_user.email}> - Company: #{team.name}"
    prompt << "</replying_user>"
    prompt << "<customer>"
    prompt << "#{thread.customer.name} <#{thread.customer.email}>"
    prompt << "</customer>"
    prompt << "<message_thread>"
    thread.messages.order(created_at: :asc).each do |message|
      prompt << "  <message>"
      prompt << "    <role>#{message.sender_type}</role>"
      prompt << "    <content>#{message.content.to_plain_text}</content>"
      prompt << "  </message>"
    end
    prompt << "</message_thread>"

    prompt_message = Ai::Agent::Message.new(
      role: "user",
      content: prompt
    )

    response = generate!(instructions: INSTRUCTIONS, messages: [
      prompt_message
    ])

    Success(response.content)
  rescue StandardError => e
    Failure(e)
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
