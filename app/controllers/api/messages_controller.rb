module Api
  class MessagesController < ApiController
    def create
      halt_bad_request!("Invalid JWT for customer") if customer.nil?

      message = message_thread.messages.create!(
        sender: customer,
        status: "received",
        content: params[:content],
        channel: "widget"
      )

      unless customer.blocked?
        NotificationService.new_message(current_team, message)

        ThreadSubjectAgent.new(
          team: current_team,
          message: message
        ).perform_async!
      end

      head :no_content
    end

    private

    def customer
      Customer.upsert_by_jwt(params[:customer_jwt], current_team)
    end

    def message_thread
      @_message_thread ||= if customer.message_threads.with_open_status.any?
        message_thread = customer.message_threads.with_open_status.first
        message_thread.update(status: "open")
        message_thread
      else
        customer.message_threads.create!(team: current_team, subject: subject, status: "open")
      end
    end

    def subject
      params.fetch(:subject, "New message")
    end
  end
end
