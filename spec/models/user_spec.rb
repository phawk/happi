require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to belong_to(:team).optional }
  it { is_expected.to have_many(:visits) }
  it { is_expected.to have_and_belong_to_many(:teams) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_inclusion_of(:role).in_array(User::ROLES) }

  describe "#role?" do
    it "checks role in hierarchies" do
      expect(User.new(role: "superadmin").role?(:superadmin)).to be(true)
      expect(User.new(role: "admin").role?(:superadmin)).to be(false)
      expect(User.new(role: "admin").role?(:admin)).to be(true)
      expect(User.new(role: "user").role?(:admin)).to be(false)
    end
  end

  describe "#assignable_roles" do
    it "allows assignment of a same or lesser role" do
      expect(User.new(role: "admin").assignable_roles).to eq(
        %w[user admin]
      )
    end
  end
end
