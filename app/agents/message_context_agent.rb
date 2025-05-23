class MessageContextAgent < ApplicationAgent
  INSTRUCTIONS = <<~INSTRUCTIONS
    Your job is to gather additional context used to answer the message using the knowledge base and previous responses.

    This context will be used by other agents to help them write a reply to the customer's message.

    Gather as much useful context as possible, but don't make up any information. If you can, cite the source of the information, if it's from the knowledge base (and which file) or previous responses.
  INSTRUCTIONS

  option :message

  def perform!
    prompt = []
    prompt << "<message>"
    prompt << "#{message.content.to_plain_text}"
    prompt << "</message>"
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
    ], tools: [:knowledge_base_tool, :previous_responses_tool])

    message.update!(ai_context: response.content)

    Success(response.content)
  rescue StandardError => e
    Failure(e)
  end

  private

  def thread
    @_thread ||= message.message_thread
  end
end
