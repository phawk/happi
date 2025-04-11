require "rails_helper"

RSpec.describe Ai::GenerateReplyController, type: :request do
  let(:user) { users(:pete) }
  let(:team) { teams(:acme) }
  let(:message_thread) { message_threads(:acme_alex_password_reset) }
  before { sign_in user }

  describe "#create" do
    context "when the agent responds successfully" do
      before do
        allow_any_instance_of(ReplyWriterAgent).to receive(:perform!).and_return(
          Dry::Monads::Success.new("Hello, how can I help you?")
        )
      end

      it "returns a success response" do
        post message_thread_ai_generate_reply_path(message_thread)
        expect(response).to be_successful
        expect(response.body).to include("Hello, how can I help you?")
      end
    end

    context "when the agent responds with an error" do
      before do
        allow_any_instance_of(ReplyWriterAgent).to receive(:perform!).and_return(Dry::Monads::Failure.new("Error"))
      end

      it "returns a failure response" do
        post message_thread_ai_generate_reply_path(message_thread)
        expect(response).to be_unprocessable
        expect(response.body).to include("Failed to generate AI reply, please try again.")
      end
    end
  end
end
