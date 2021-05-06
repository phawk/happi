require "rails_helper"

RSpec.describe "Messages", type: :request do
  describe "POST /messages" do
    let(:pete) { users(:pete) }
    let(:message_thread) { message_threads(:payhere_alex_password_reset) }

    context "when params are valid" do
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

      it "assigns current user to the thread" do
        expect(message_thread.user).to eq(pete)
      end

      it "sends an email" do
        expect(delivered_emails.size).to eq(1)
        expect(last_email.subject).to eq(message_thread.subject)
        expect(last_email.to).to eq([message_thread.customer.email])
        expect(last_email.reply_to).to eq(["support@payhere.co"])
      end
    end

    context "when params are invalid" do
      it "returns an error" do
        sign_in(pete)
        post message_thread_messages_path(message_thread), params: { message: { content: "" } }

        expect(response).to redirect_to(message_thread_path(message_thread))
        follow_redirect!
        expect(response.body).to include("You must enter a message")
      end
    end
  end

  describe "GET /view_message/:id" do
    let(:message) { messages(:payhere_alex_stripe_msg_1) }

    context "when user belongs to team" do
      let!(:pete) { sign_in(users(:pete)) }

      it "switches team and shows message" do
        pete.update!(team: nil)

        get view_message_path(message)

        follow_redirect!

        expect(response.body).to include("Switched to Payhere")
        expect(response.body).to include(message.content.to_s)
      end
    end

    context "when user doesn't belong to team" do
      let!(:scott) { sign_in(users(:scott)) }

      it "displays an error message" do
        get view_message_path(message)

        expect(response).to redirect_to(message_threads_path)
        follow_redirect!
        expect(response.body).to include("You don’t have access to this team")
      end
    end
  end
end
