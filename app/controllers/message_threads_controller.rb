class MessageThreadsController < ApplicationController
  def index
    @message_threads = current_team.message_threads.includes(:customer, :messages)
  end

  def show
    @message_thread = current_team.message_threads.find(params[:id])
    @customer = @message_thread.customer
    @messages = @message_thread.messages.order(:created_at)
  end
end
