require "rails_helper"

RSpec.describe BlockedDomain, type: :model do
  describe ".domain_from_email" do
    it "returns the domain" do
      domain = BlockedDomain.domain_from_email("bob@example.com")
      expect(domain).to eq("example.com")
    end

    it "returns nil when there is no domain" do
      domain = BlockedDomain.domain_from_email("bob")
      expect(domain).to be_nil
    end
  end

  describe ".blocked?" do
    it "returns true if the emails domain is blocked" do
      BlockedDomain.create!(team: teams(:acme), domain: "apple.com")
      expect(BlockedDomain.blocked?("tim@apple.com")).to be(true)
    end

    it "returns false if the emails domain is NOT blocked" do
      expect(BlockedDomain.blocked?("tim@apple.com")).to be(false)
    end

    it "returns false if invalid value is passed" do
      expect(BlockedDomain.blocked?("")).to be(false)
      expect(BlockedDomain.blocked?(nil)).to be(false)
    end
  end

  describe "#block_matching_customers!" do
    it "blocks customers with a matching domain" do
      BlockedDomain.new(team: teams(:acme), domain: "hotmail.com").block_matching_customers!
      expect(customers(:acme_alex)).to be_blocked
    end
  end

  describe "#unblock_matching_customers!" do
    let(:customer) { customers(:acme_alex) }

    it "unblocks customers with a matching domain" do
      customer.update!(blocked: true)
      BlockedDomain.new(team: teams(:acme), domain: "hotmail.com").unblock_matching_customers!
      expect(customer.reload).not_to be_blocked
    end
  end
end
