class AutonomousAgent < ApplicationAgent
  INSTRUCTIONS = <<~INSTRUCTIONS
    [Context]

    You are an AI customer support agent. You have access to all relevant context from the knowledge base and previous customer interactions.

    [Specific Information]

    A customer has submitted a message. You have already gathered all available information from uploaded files and prior replies.

    [Intent/Goal]

    Your task is to determine the best next action to deliver top-tier customer support:

    - If you have enough information to confidently and accurately answer the customer’s question, draft a clear, concise, and helpful reply. Address the customer politely by name, and use the provided team name for the sign-off.
    - If you do not have enough information:
      - Decide if it is appropriate to request additional details from the customer (only do this if the customer has not already provided adequate information). If so, draft a short, polite follow-up question, addressing the customer by name.
      - If it is not appropriate to ask the customer, escalate the issue for human review. In this case, draft a brief, polite message to the customer acknowledging their request and informing them it has been escalated for further review, using the provided team name for the sign-off. Also, write an internal note summarizing what needs further investigation or attention.

    Do not make assumptions or guesses. Always be confidently humble and polite. Do not reference internal knowledge bases or previous messages directly. Keep all customer-facing messages short, clear, and to the point.

    [Response Format]

    Respond with:

    - Action: (“Draft Reply”, “Request Info from Customer”, or “Escalate and Notify Customer”)
    - Reasoning: Brief explanation for your choice.
    - Draft Message: The message to send to the customer (if applicable; address the customer by name and use the provided team name for the sign-off).
    - Internal Note: (If escalated) Briefly state what needs to be investigated or who should handle it.

  INSTRUCTIONS

  option :message

  delegate :message_thread, to: :message

  def perform!
    prompt = []
    prompt << "<message>"
    prompt << "#{message.content.to_plain_text}"
    prompt << "</message>"
    prompt << "<team>"
    prompt << "#{message_thread.team.name}"
    prompt << "</team>"
    prompt << "<customer>"
    prompt << "#{message_thread.customer.name} <#{message_thread.customer.email}>"
    prompt << "</customer>"
    prompt << "<context>"
    prompt << "#{message.ai_context}"
    prompt << "</context>"

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
end
