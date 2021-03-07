require "rails_helper"

RSpec.describe CustomEmailAddress, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:user).optional }

  it { is_expected.to validate_presence_of(:email) }

  describe ".matching_emails" do
    it "returns the first matching team for provided list of recipients" do
      email = CustomEmailAddress.matching_emails( ["support@payhere.co"])
      expect(email.team.name).to eq("Payhere")
    end

    it "ignores unconfirmed custom emails" do
      email = CustomEmailAddress.matching_emails( ["unconfirmed@payhere.co"])
      expect(email).to be_nil
    end

    it "returns nil when email not found" do
      email = CustomEmailAddress.matching_emails( ["joe@invalid.org"])
      expect(email).to be_nil
    end
  end
end
