module Messages
  class SpamChecksController < ApplicationController
    before_action :set_thread
    before_action :set_message

    def create
      @message = Message.find(params[:message_id])

      result = Ai::DetectSpamService.new(message: @message, force_thread_update: true, model: "gpt-4o-mini").call

      if result.success?
        redirect_to message_thread_path(@message_thread), notice: "Spam check completed"
      else
        redirect_to message_thread_path(@message_thread), alert: "Error checking spam"
      end
    end

    private

    def set_thread
      @message_thread = current_team.message_threads.find(params[:message_thread_id])
    end

    def set_message
      @message = @message_thread.messages.find(params[:message_id])
    end
  end
end
