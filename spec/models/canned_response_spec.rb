require "rails_helper"

RSpec.describe CannedResponse, type: :model do
  it { is_expected.to belong_to :team }
  it { is_expected.to validate_presence_of :label }
end
