require "rails_helper"
require "vcr_helper"

RSpec.describe ProcessMessageThreadReplyJob, type: :job do
  let(:message_thread) { message_threads(:acme_alex_stripe) }

  it "creates a ReplyStatistic and an Embedding", :vcr do
    expect do
      subject.perform(message_thread)
    end.to change(ReplyStatistic, :count).by(1)

    expect(ReplyStatistic.last.team).to eq(message_thread.team)
    expect(ReplyStatistic.last.message_thread).to eq(message_thread)
    expect(ReplyStatistic.last.message_ids).to eq([messages(:acme_alex_stripe_msg_1).id.to_s])
    expect(ReplyStatistic.last.reply_ids).to eq([messages(:acme_alex_stripe_msg_2).id.to_s])
    expect(ReplyStatistic.last.time_to_reply).to eq(7405)
  end
end
