require "rails_helper"

RSpec.describe CannedResponse, type: :model do
  before { Current.team = teams(:acme) }

  it { is_expected.to belong_to(:team).optional }
  it { is_expected.to validate_presence_of :label }
end
