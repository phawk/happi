require "rails_helper"

RSpec.describe ProcessNewMessageJob, type: :job do
  let(:message) { messages(:acme_alex_password_reset_msg_1) }

  it "calls NotificationService" do
    allow(NotificationService).to receive(:new_message).and_return(true)

    subject.perform(message)

    expect(NotificationService).to have_received(:new_message).with(message.message_thread.team, message)
  end
end
