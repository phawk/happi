class Ai::Tools::AutonomousTool < Ai::Tools::BaseTool
  include ActionView::Helpers::TextHelper

  define_function :create_internal_note, description: "Create an internal note" do
    property :note, type: "string", description: "The note to create", required: true
  end

  define_function :reply_to_customer, description: "Reply to the customer" do
    property :email_text, type: "string", description: "The message to send to the customer", required: true
  end

  def create_internal_note(note:)
    message = message_thread.messages.create!(
      sender: team,
      content: simple_format(note),
      ai_agent: true,
      internal: true
    )

    NotificationService.new_internal_note(team, message)
  end

  def reply_to_customer(email_text:)
    message = message_thread.messages.create!(
      sender: team,
      content: simple_format(email_text),
      ai_agent: true,
      draft: !team.autonomous_replies_enabled?
    )

    unless message.draft?
      message_thread.update(status: "waiting")
      CustomerMailer.new_reply(message).deliver_later
      ProcessMessageThreadReplyJob.perform_later(message_thread)
    end
  end

  private

  def message
    agent.message
  end

  def message_thread
    message.message_thread
  end
end
