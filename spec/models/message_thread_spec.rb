require "rails_helper"

RSpec.describe MessageThread, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:user).optional }
  it { is_expected.to have_many(:messages) }

  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_inclusion_of(:status).in_array(MessageThread::STATUS) }

  describe "#reply_to_address" do
    it "returns reply_to if set" do
      thread = MessageThread.new(team: teams(:payhere), reply_to: "support@payhere.co")
      expect(thread.reply_to_address).to eq("support@payhere.co")
    end

    it "returns default mailbox for team if reply_to is empty" do
      thread = MessageThread.new(team: teams(:payhere), reply_to: nil)
      expect(thread.reply_to_address).to eq("payhere@in.happi.team")
    end
  end

  describe "#previous_threads" do
    let(:thread) { message_threads(:payhere_alex_password_reset) }

    it "looks for previous threads from the same customer" do
      expect(thread.previous_threads.count).to eq(1)
      expect(thread.previous_threads.first.subject).to eq("Connected wrong stripe")
    end
  end

  describe "#merge_with_previous!" do
    let(:thread) { message_threads(:payhere_alex_password_reset) }

    it "merges thread into the previous thread" do
      expect do
        previous_thread = thread.merge_with_previous!
        expect(previous_thread.messages.count).to eq(3)
      end.to change { MessageThread.count }.by(-1)
    end
  end
end
