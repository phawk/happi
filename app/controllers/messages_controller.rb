class MessagesController < ApplicationController
  before_action :set_thread, except: :view_message
  skip_before_action :ensure_team!, only: :view_message

  def new
    @message = Message.new
  end

  def create
    unless current_user.can_send_messages?
      return redirect_to @message_thread, alert: "Message failed to send"
    end

    message = @message_thread.messages.create(message_params)

    if message.persisted?
      unless message.internal?
        @message_thread.update(status: "waiting", user: current_user)
        CustomerMailer.new_reply(message).deliver_later
      end

      redirect_to @message_thread, notice: "Message delivered"
    else
      flash[:error] = "You must enter a message"
      redirect_to @message_thread
    end
  end

  def hovercard
    @message = @message_thread.messages.find(params[:id])
    render layout: false
  end

  def view_message
    message = Message.find(params[:id])
    team = message.message_thread.team
    if current_user.teams.exists?(team.id)
      if current_user.team_id != team.id
        current_user.update(team: team)
        flash[:notice] = t(".switched_to", team: team.name)
      end

      redirect_to message_thread_url(message.message_thread, anchor: dom_id(message))
    else
      flash[:error] = t(".no_access")
      redirect_to message_threads_path
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
