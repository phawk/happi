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
      partial: "messages/form",
      locals: {
        model: [@message_thread, Message.new(content: message)],
        thread: @message_thread,
        ai_status: status,
        current_user: current_user,
        current_team: current_team,
        canned_responses: current_team.canned_responses.order(:created_at).to_a
      }
    )
  end

  def set_message_thread
    @message_thread = current_team.message_threads.find(params[:message_thread_id])
  end
end
