class ThreadSubjectAgent < ApplicationAgent
  INSTRUCTIONS = <<~INSTRUCTIONS
    Take the message and write a short, concise subject line for the message thread. The message is a customer support request.

    Return ONLY the subject line, no other text or comments.
  INSTRUCTIONS

  option :message

  delegate :message_thread, to: :message

  def perform!
    prompt = <<~PROMPT
      <message>
        #{message.content.to_plain_text}
      </message>
    PROMPT

    prompt_message = Ai::Agent::Message.new(
      role: "user",
      content: prompt
    )

    response = generate!(instructions: INSTRUCTIONS, messages: [
      prompt_message
    ])

    message_thread.update!(subject: response&.content)

    Success(subject: response&.content)
  rescue StandardError => e
    Failure("ThreadSubjectAgent error for message #{message.id}: #{e.message}")
  end
end
