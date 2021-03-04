require "rails_helper"

RSpec.describe Message, type: :model do
  it { is_expected.to belong_to(:message_thread) }
  it { is_expected.to belong_to(:sender) }
end
