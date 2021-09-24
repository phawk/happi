class MessageThreadsController < ApplicationController
  before_action :set_thread, only: %i[show update destroy merge_with_previous]

  def index
    @open_message_threads = current_team.allowed_threads.with_open_status.includes(:customer, :user,
      :messages).most_recent.to_a
    @previous_message_threads = current_team.allowed_threads.without_open_status.includes(:customer, :user,
      :messages).most_recent.limit(50).to_a
  end

  def show
    @customer = @message_thread.customer
    @messages = @message_thread.messages.with_rich_text_content_and_embeds.order(:created_at)
    @canned_responses = current_team.canned_responses.order(:created_at).to_a
  end

  def new
    @customer = current_team.customers.find(params[:customer_id])
    @message_thread = MessageThread.new
  end

  def create
    @customer = current_team.customers.find(create_params[:customer_id])
    @message_thread = current_team.message_threads.new(create_params.merge(user: current_user, status: "open"))

    if @message_thread.save
      redirect_to @message_thread
    else
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @customer, alert: "Oops, we could not create your thread, try again" }
      end
    end
  end

  def update
    if @message_thread.update(update_params)
      redirect_to @message_thread, notice: t(".success")
    else
      redirect_to @message_thread, alert: t(".failed")
    end
  end

  def destroy
    @message_thread.archive!
    redirect_to message_threads_path, notice: "Thread archived"
  end

  def merge_with_previous
    previous = @message_thread.merge_with_previous!

    if previous.present?
      redirect_to previous, notice: t(".threads_merged")
    else
      redirect_to @message_thread, notice: t(".threads_not_merged")
    end
  end

  private

  def set_thread
    @message_thread = current_team.message_threads.find(params[:id])
  end

  def create_params
    params.require(:message_thread).permit(:customer_id, :subject)
  end

  def update_params
    params.require(:message_thread).permit(:status, :user_id)
  end
end
