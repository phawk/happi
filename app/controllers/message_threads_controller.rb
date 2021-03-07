class MessageThreadsController < ApplicationController
  before_action :set_thread, only: %i[show update]

  def index
    @open_message_threads = current_team.message_threads.with_open_status.includes(:customer, :user, :messages).most_recent
    @previous_message_threads = current_team.message_threads.without_open_status.includes(:customer, :user, :messages).most_recent.limit(50)
  end

  def show
    @customer = @message_thread.customer
    @messages = @message_thread.messages.order(:created_at)
  end

  def update
    if @message_thread.update(update_params)
      redirect_to @message_thread, notice: t(".success")
    else
      redirect_to @message_thread, alert: t(".failed")
    end
  end

  private

  def set_thread
    @message_thread = current_team.message_threads.find(params[:id])
  end

  def update_params
    params.require(:message_thread).permit(:status, :user_id)
  end
end
