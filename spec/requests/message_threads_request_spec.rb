require "rails_helper"

RSpec.describe "MessageThreads", type: :request do
  before { sign_in(users(:pete)) }

  describe "GET /threads/search?query=" do
    it "searches messages" do
      search_query = "Stripe account has been disconnected"
      message = messages(:acme_alex_stripe_msg_2)
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

  describe "POST /threads/:id/merge_with_previous" do
    let(:thread) { message_threads(:acme_alex_password_reset) }
    let(:previous_thread) { message_threads(:acme_alex_stripe) }

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

  describe "GET /threads/new" do
    it "returns http success" do
      get new_message_thread_path, params: { customer_id: customers(:acme_alex).id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /threads" do
    let(:message_thread) { MessageThread.last }

    before do
      post message_threads_path, params: {
        message_thread: {
          customer_id: customers(:acme_alex).id,
          subject: "Welcome",
          reply_to: "support@acme.com",
        },
      }
    end

    it "creates a new thread" do
      expect(response).to redirect_to(message_thread)
    end

    it "sets the reply_to correctly" do
      expect(message_thread.reply_to).to eq("support@acme.com")
    end
  end

  describe "DELETE /threads/auto_archive" do
    let(:thread_1) { message_threads(:acme_alex_password_reset) }
    let(:thread_2) { message_threads(:acme_alex_stripe) }

    it "archives waiting threads older than 7 days" do
      thread_1.update!(status: "waiting", created_at: 6.days.ago)
      thread_1.messages.order(:created_at).update_all(created_at: 6.days.ago)
      thread_2.update!(status: "waiting", created_at: 8.days.ago)
      thread_2.messages.order(:created_at).update_all(created_at: 8.days.ago)

      delete auto_archive_message_threads_path

      expect(response).to redirect_to(message_threads_path)
      expect(thread_1.reload.status).to eq("waiting")
      expect(thread_2.reload.status).to eq("archived")
    end

    it "archives open threads older than 45 days" do
      thread_1.update!(status: "open", created_at: 46.days.ago)
      thread_1.messages.order(:created_at).update_all(created_at: 46.days.ago)
      thread_2.update!(status: "open", created_at: 44.days.ago)
      thread_2.messages.order(:created_at).update_all(created_at: 44.days.ago)

      delete auto_archive_message_threads_path

      expect(response).to redirect_to(message_threads_path)
      expect(thread_1.reload.status).to eq("archived")
      expect(thread_2.reload.status).to eq("open")
    end

    it "archives closed threads older than 7 days" do
      thread_1.update!(status: "closed", created_at: 6.days.ago)
      thread_1.messages.order(:created_at).update_all(created_at: 6.days.ago)
      thread_2.update!(status: "closed", created_at: 8.days.ago)
      thread_2.messages.order(:created_at).update_all(created_at: 8.days.ago)

      delete auto_archive_message_threads_path

      expect(response).to redirect_to(message_threads_path)
      expect(thread_1.reload.status).to eq("closed")
      expect(thread_2.reload.status).to eq("archived")
    end
  end
end
