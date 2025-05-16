class Ai::GenerateReplyController < ApplicationController
  before_action :set_message_thread

  def create
    agent = ReplyWriterAgent.new(
      thread: @message_thread,
      current_user: current_user,
      team: current_team
    )
    result = agent.perform!

    if result.success?
      render turbo_stream: turbo_stream_response("success", result.value!)
    else
      render turbo_stream: turbo_stream_response("failed", nil), status: :unprocessable_entity
    end
  end

  private

  def turbo_stream_response(status, message)
    turbo_stream.replace(
      "message-composer-form",
      html: Messages::FormComponent.new(
        message: Message.new(content: message),
        message_thread: @message_thread,
        ai_status: status,
        canned_responses: current_team.canned_responses.order(:created_at).to_a,
        emails_to_send_from: current_team.emails_to_send_from,
        can_send_messages: current_user.can_send_messages?
      ).render_in(view_context)
    )
  end

  def set_message_thread
    @message_thread = current_team.message_threads.find(params[:message_thread_id])
  end
end
