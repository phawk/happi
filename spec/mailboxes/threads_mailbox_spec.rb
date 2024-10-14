require "rails_helper"

RSpec.describe ThreadsMailbox, type: :mailbox do
  context "when happi email address is used" do
    context "when there is no open thread" do
      it "creates thread and posts new message" do
        perform_enqueued_jobs do
          expect do
            send_mail(to: "acme@prioritysupport.net", headers: { "X-Spam-Score" => "-6.0" })
          end.to change(MessageThread, :count).by(1)

          last_message = Message.last

          expect(last_message.content.to_s).to include("What's the status?")
          expect(last_message.sender.email).to eq("jack@jackjohnson.net")
          expect(last_message.sender.name.full).to eq("Jack Johnson")
          expect(last_message.spam_score).to eq(-6.0)
          expect(last_message.raw).not_to be_nil
          expect(last_message.action_mailbox_id).not_to be_nil
        end
      end

      it "sends a notification to the team" do
        expect(NotificationService).to receive(:new_message).with(teams(:acme), an_instance_of(Message))

        perform_enqueued_jobs do
          send_mail(to: "acme@prioritysupport.net")
        end
      end
    end

    context "when there is an open thread already" do
      let(:thread) { message_threads(:acme_alex_password_reset) }

      before { thread.update!(status: "waiting") }

      it "adds new message to the thread" do
        perform_enqueued_jobs do
          expect do
            send_mail(to: "acme@prioritysupport.net", from: "Alex Shaw <alex.shaw09@hotmail.com>")
          end.to change { message_threads(:acme_alex_password_reset).messages.count }.by(1)
          thread.reload

          expect(thread.status).to eq("open")
        end
      end
    end

    context "when the customer is marked as blocked" do
      before { customers(:acme_alex).update(blocked: true) }

      it "creates a message but doesn't send notification" do
        perform_enqueued_jobs do
          expect do
            send_mail(to: "acme@prioritysupport.net", from: "alex.shaw09@hotmail.com")
          end.to change(Message, :count).by(1)

          expect(delivered_emails.size).to eq(0)
        end
      end
    end

    context "when the customer's domain is blocked" do
      before { teams(:acme).blocked_domains.create!(domain: "hotmail.com") }

      it "creates a message but doesn't send notification and blocks the customer" do
        perform_enqueued_jobs do
          expect do
            send_mail(to: "acme@prioritysupport.net", from: "frank@hotmail.com")
          end.to change(Message, :count).by(1)

          customer = Customer.last
          expect(customer.email).to eq("frank@hotmail.com")
          expect(customer).to be_blocked
          expect(delivered_emails.size).to eq(0)
        end
      end
    end
  end

  context "when a custom email address is used" do
    it "creates a thread and message" do
      perform_enqueued_jobs do
        expect do
          send_mail(to: "support@acme.com")
        end.to change(MessageThread, :count).by(1)

        last_thread = MessageThread.last

        expect(last_thread.messages.count).to eq(1)
        expect(last_thread.reply_to).to eq("support@acme.com")
      end
    end
  end

  context "when an HTML email is sent" do
    it "stores the original_html" do
      perform_enqueued_jobs do
        expect do
          receive_inbound_email_from_fixture("email_with_attachment")
        end.to change(MessageThread, :count).by(1)

        last_message = Message.last
        expect(last_message.raw).not_to be_nil
        expect(last_message.original_html).not_to be_nil
        expect(last_message.action_mailbox_id).not_to be_nil
      end
    end
  end

  context "when an the email  has no subject" do
    it "uses a default subject" do
      perform_enqueued_jobs do
        expect do
          receive_inbound_email_from_fixture("email_without_subject")
        end.to change(MessageThread, :count).by(1)

        last_message = Message.last
        expect(last_message.raw).not_to be_nil
        expect(last_message.action_mailbox_id).not_to be_nil
      end
    end
  end

  context "when team not found" do
    it "raises an error" do
      perform_enqueued_jobs do
        expect do
          send_mail(to: "bad@prioritysupport.net")
        end.to raise_error(ThreadsMailbox::TeamNotFoundError)
      end
    end
  end

  def send_mail(to:, from: "Jack Johnson <Jack@jackjohnson.net>", headers: {})
    receive_inbound_email_from_mail do |mail|
      headers&.each do |key, val|
        mail.header[key] = val
      end
      mail.to = to
      mail.from = from
      mail.subject = "Status update?"
      mail.body = <<~BODY
        What's the status?
      BODY
    end
  end
end
