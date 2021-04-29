require "rails_helper"

RSpec.describe BetaSignup, type: :model do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to belong_to(:team).optional }
end
