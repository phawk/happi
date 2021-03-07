class MessagesController < ApplicationController
  before_action :set_thread

  def new
    @message = Message.new
  end

  def create
    message = @message_thread.messages.create!(message_params)

    @message_thread.update(status: "waiting")

    unless message.internal?
      CustomerMailer.new_reply(message).deliver_later
    end

    # TODO turbo stream to insert the message
    redirect_to @message_thread, notice: "Message delivered"
  end

  private

  def message_params
    params.require(:message)
          .permit(:content, :internal)
          .merge(sender: current_user)
  end

  def set_thread
    @message_thread = current_team.message_threads.find(params[:message_thread_id])
  end
end
