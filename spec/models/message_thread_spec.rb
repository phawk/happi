require "rails_helper"

RSpec.describe MessageThread, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:user).optional }
  it { is_expected.to have_many(:messages) }
end
