require "rails_helper"

RSpec.describe Customer, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to have_many(:message_threads) }
end
