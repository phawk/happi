require "rails_helper"

RSpec.describe ThreadsMailbox, type: :mailbox do
  context "successful delivery" do
    context "when happi email address is used"
    context "when a custom email address is used"
    context "when X-Original-From is set"
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

  def send_mail(to:)
    receive_inbound_email_from_mail \
        to: to,
        from: "Jack Johnson <jack@jackjohnson.net>",
        subject: "Status update?",
        body: <<~BODY
          What's the status?
        BODY
  end
end
