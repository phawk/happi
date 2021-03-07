require "rails_helper"

RSpec.describe CustomEmailAddress, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:user).optional }

  it { is_expected.to validate_presence_of(:email) }

  describe ".matching_team_for(emails: [])" do
    it "returns the first matching team for provided list of recipients" do
      team = CustomEmailAddress.matching_team_for(emails: ["support@payhere.co"])
      expect(team.name).to eq("Payhere")
    end

    it "returns nil when team not found" do
      team = CustomEmailAddress.matching_team_for(emails: ["joe@invalid.org"])
      expect(team).to be_nil
    end
  end
end
