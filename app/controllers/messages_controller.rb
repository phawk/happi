class MessagesController < ApplicationController
  before_action :set_thread

  def new
    @message = Message.new
  end

  def create
    if current_team.verified?
      message = @message_thread.messages.create!(message_params)

      unless message.internal?
        @message_thread.update(status: "waiting", user: current_user)
        CustomerMailer.new_reply(message).deliver_later
      end

      redirect_to @message_thread, notice: "Message delivered"
    else
      redirect_to @message_thread, alert: "Message not sent. Your account is in review."
    end
  end

  private

  def message_params
    params.require(:message)
          .permit(:content, :from_address, :internal)
          .merge(sender: current_user)
  end

  def set_thread
    @message_thread = current_team.message_threads.find(params[:message_thread_id])
  end
end
