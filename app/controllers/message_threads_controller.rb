class MessageThreadsController < ApplicationController
  before_action :set_thread, only: %i[show update destroy merge_with_previous]
  before_action :set_counters, only: %i[index spam blocked]

  def index
    @open_message_threads = current_team.allowed_threads.ham(current_team).with_open_status.includes(:customer, :user,
      :messages).most_recent.to_a
    @previous_message_threads = current_team.allowed_threads.ham(current_team).without_open_status.includes(:customer, :user,
      :messages).most_recent.limit(50).to_a
  end

  def spam
    @open_message_threads = current_team.allowed_threads.spam(current_team).with_open_status.includes(:customer, :user,
      :messages).most_recent.to_a
    @previous_message_threads = current_team.allowed_threads.spam(current_team).with_closed_and_archived.includes(:customer, :user,
      :messages).most_recent.limit(50).to_a
    render :index # Use the same view template as index
  end

  def blocked
    @open_message_threads = current_team.blocked_threads.with_open_status.includes(:customer, :user,
    :messages).most_recent.to_a
    @previous_message_threads = current_team.blocked_threads.with_closed_and_archived.includes(:customer, :user, :messages).most_recent.limit(50).to_a
    render :index # Use the same view template as index
  end

  def search
    @query = params[:query]
    messages = current_team.messages.with_rich_text_content.includes(:message_thread).search(@query)
    @results = GroupedSearchResults.new(messages).grouped
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

  def auto_archive
    current_team.allowed_threads.with_open_status.find_each do |thread|
      last_message = thread.messages.order(:created_at).last
      next unless last_message

      if thread.status == "open" && last_message.created_at < 45.days.ago
        thread.archive!
      end

      if thread.status == "waiting" && last_message.created_at < 7.days.ago
        thread.archive!
      end
    end

    current_team.allowed_threads.without_open_status.find_each do |thread|
      last_message = thread.messages.order(:created_at).last
      next unless last_message

      if last_message.created_at < 7.days.ago
        thread.archive!
      end
    end

    redirect_to message_threads_path, notice: "Auto archive complete"
  end

  private

  def set_counters
    @spam_threads_count = current_team.allowed_threads.spam(current_team).without_archived.count
    @blocked_threads_count = current_team.blocked_threads.count
  end

  def set_thread
    @message_thread = current_team.message_threads.find(params[:id])
  end

  def create_params
    params.require(:message_thread).permit(:customer_id, :subject, :reply_to)
  end

  def update_params
    params.require(:message_thread).permit(:status, :user_id)
  end
end
