require "rails_helper"

RSpec.describe Team, type: :model do
  it { is_expected.to have_and_belong_to_many(:users) }
  it { is_expected.to have_many(:customers) }
  it { is_expected.to have_many(:message_threads) }
  it { is_expected.to have_many(:custom_email_addresses) }

  it { is_expected.to validate_presence_of(:name) }
end
