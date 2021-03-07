require "rails_helper"

RSpec.describe MessageThread, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:user).optional }
  it { is_expected.to have_many(:messages) }

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
end
