class CustomerMailer < ApplicationMailer
  layout "mailers/plain"

  def new_reply(message)
    @message  = message
    @message_thread = message.message_thread
    @customer = @message_thread.customer

    mail to: @customer.email, subject: @message_thread.subject
  end
end
