require "rails_helper"

RSpec.describe ThreadsMailbox, type: :mailbox do
  context "successful delivery" do
    context "when happi email address is used" do
      context "and there is no open thread" do
        it "creates thread and posts new message" do
          perform_enqueued_jobs do
            expect do
              send_mail(to: "payhere@in.happi.team")
            end.to change { MessageThread.count }.by(1)

            last_message = Message.last

            expect(last_message.content.to_s).to include("What's the status?")
            expect(last_message.sender.email).to eq("jack@jackjohnson.net")
            expect(last_message.sender.name.full).to eq("Jack Johnson")
          end
        end
      end

      context "and there is an open thread already" do
        let(:thread) { message_threads(:payhere_alex_password_reset) }

        before { thread.update!(status: "waiting") }

        it "adds new message to the thread" do
          perform_enqueued_jobs do
            expect do
              send_mail(to: "payhere@in.happi.team", from: "Alex Shaw <alex.shaw09@hotmail.com>")
            end.to change { message_threads(:payhere_alex_password_reset).messages.count }.by(1)
            thread.reload

            expect(thread.status).to eq("open")
          end
        end
      end
    end

    context "when a custom email address is used" do
      it "creates a thread and message" do
        perform_enqueued_jobs do
          expect do
            send_mail(to: "support@payhere.co")
          end.to change { MessageThread.count }.by(1)

          last_thread = MessageThread.last

          expect(last_thread.messages.count).to eq(1)
          expect(last_thread.reply_to).to eq("support@payhere.co")
        end
      end
    end

    context "when X-Original-From is set" do
      it "Uses this over the original from" do
        perform_enqueued_jobs do
          send_mail(to: "support@payhere.co", from: "Payhere Support <support@payhere.co>", headers: {
            "X-Original-From" => "Jeffry Jefferson <jeffry.jefferson@aol.com>",
          })

          last_message = Message.last

          expect(last_message.sender.email).to eq("jeffry.jefferson@aol.com")
          expect(last_message.sender.name.full).to eq("Jeffry Jefferson")
        end
      end
    end
  end

  context "when team not found" do
    it "bounces and emails the sender" do
      perform_enqueued_jobs do
        send_mail(to: "bad@in.happi.team")

        expect(delivered_emails.size).to eq(1)
        expect(last_email.to.first).to eq("jack@jackjohnson.net")
        expect(last_email.subject).to eq("Team doesn't exist")
      end
    end
  end

  def send_mail(to:, from: "Jack Johnson <jack@jackjohnson.net>", headers: {})
    receive_inbound_email_from_mail do |mail|
      if headers
        headers.each do |key, val|
          mail.header[key] = val
        end
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
