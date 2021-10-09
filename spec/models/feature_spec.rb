require "rails_helper"

RSpec.describe Feature, type: :model do
  let(:admin_user) { users(:pete) }
  let(:standard_user) { users(:scott) }

  describe ".enabled?" do
    it "returns true by default" do
      expect(Feature.enabled?(:unknown)).to be(true)
    end

    context "when a feature flag depends on user" do
      it "is enabled for admins" do
        expect(Feature.enabled?(:changelog, admin_user)).to be(true)
      end

      it "is disabled for standard users" do
        expect(Feature.enabled?(:changelog, standard_user)).to be(false)
      end

      it "is disabled for logged out users" do
        expect(Feature.enabled?(:changelog)).to be(false)
      end
    end
  end
end
