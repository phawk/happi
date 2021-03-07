require "rails_helper"

RSpec.describe "Messages", type: :request do
  describe "#create" do
    let(:pete) { users(:pete) }
    let(:message_thread) { message_threads(:payhere_alex_password_reset) }

    before do
      sign_in(pete)
      perform_enqueued_jobs do
        post message_thread_messages_path(message_thread), params: { message: { content: "Thanks for getting in touch!" } }
      end
      message_thread.reload
    end

    it "creates message" do
      expect(Message.last.content.to_s).to include("Thanks for getting in touch!")
      expect(Message.last.sender).to eq(pete)
    end

    it "sets thread to 'waiting'" do
      expect(message_thread.status).to eq("waiting")
    end

    it "sends an email" do
      expect(delivered_emails.size).to eq(1)
      expect(last_email.subject).to eq(message_thread.subject)
      expect(last_email.to).to eq([message_thread.customer.email])
      expect(last_email.reply_to).to eq(["support@payhere.co"])
    end
  end
end
