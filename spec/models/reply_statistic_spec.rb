require "rails_helper"

RSpec.describe ReplyStatistic, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:message_thread) }
end
