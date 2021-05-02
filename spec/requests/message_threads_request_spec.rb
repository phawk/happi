require "rails_helper"

RSpec.describe "MessageThreads", type: :request do
  before { sign_in(users(:pete)) }

  describe "POST /message_threads/:id/merge_with_previous" do
    let(:thread) { message_threads(:payhere_alex_password_reset) }
    let(:previous_thread) { message_threads(:payhere_alex_stripe) }

    it "merges two threads into one" do
      post merge_with_previous_message_thread_path(thread)

      expect(response).to redirect_to(message_thread_path(previous_thread))
      follow_redirect!
      expect(response.body).to include("Threads merged")
    end

    it "returns an error when there is no previous thread" do
      post merge_with_previous_message_thread_path(previous_thread)

      expect(response).to redirect_to(message_thread_path(previous_thread))
      follow_redirect!
      expect(response.body).to include("No previous threads found")
    end
  end
end
