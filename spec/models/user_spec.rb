require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to belong_to(:team).optional }
  it { is_expected.to have_and_belong_to_many(:teams) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
end
