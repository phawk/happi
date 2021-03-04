require "rails_helper"

RSpec.describe Customer, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to have_many(:message_threads) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:email) }
end
