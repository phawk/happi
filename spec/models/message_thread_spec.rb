require "rails_helper"

RSpec.describe MessageThread, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:user).optional }
  it { is_expected.to have_many(:messages) }

  it { is_expected.to validate_inclusion_of(:status).in_array(MessageThread::STATUS) }
end
