require "rails_helper"

RSpec.describe "MessageThreads", type: :request do
  before { sign_in(users(:pete)) }

  describe "GET /message_threads/search?query=" do
    it "searches messages" do
      search_query = "Stripe account has been disconnected"
      message = messages(:payhere_alex_stripe_msg_2)
      message_link = message_thread_path(message.message_thread, anchor: "message_#{message.id}")

      get search_message_threads_path(query: search_query)
      expect(response).to have_http_status(:success)
      expect(response.body).to include message_link
    end

    it "displays an error if no messages are found" do
      get search_message_threads_path(query: "abjnjasndjsn")
      expect(response).to have_http_status(:success)
      expect(response.body).to include "No results"
    end
  end

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
