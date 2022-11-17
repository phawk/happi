require "rails_helper"

RSpec.describe "BlockedDomains", type: :request do
  let(:team) { teams(:acme) }
  let(:customer) { customers(:acme_alex) }
  before { sign_in(users(:pete)) }

  describe "POST /blocked_domains" do
    it "creates a blocked domain" do
      expect do
        post "/blocked_domains", params: {
          email: customer.email
        }
        blocked_domain = BlockedDomain.last
        expect(blocked_domain.domain).to eq("hotmail.com")
        expect(response).to redirect_to(customer)
      end.to change(BlockedDomain, :count).by(1)
    end

    it "blocks customers with matching domains" do
      post "/blocked_domains", params: {
        email: customer.email
      }

      expect(customer.reload).to be_blocked
    end
  end

  describe "DELETE /blocked_domains/:id" do
    let!(:blocked_domain) do
      team.blocked_domains.create!(domain: "apple.com")
    end

    let!(:bob) { team.customers.create!(name: "Bob", email: "bob@apple.com", blocked: true) }

    it "deletes the blocked_domain and unblocks all customers with that domain" do
      expect do
        delete "/blocked_domains/#{blocked_domain.id}"

        expect(response).to redirect_to(blocked_domains_settings_path)
        expect(bob.reload).not_to be_blocked
      end.to change(BlockedDomain, :count).by(-1)
    end
  end
end
