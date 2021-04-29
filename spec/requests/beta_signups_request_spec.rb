require "rails_helper"

RSpec.describe "BetaSignups", type: :request do
  context "when valid" do
    it "creates a beta signup" do
      post beta_signups_path, params: { beta_signup: { email: "Petey@hey.com" } }
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Thanks for registering")
    end
  end

  context "when email exists" do
    before { BetaSignup.create!(email: "petey@hey.com") }

    it "returns an error" do
      post beta_signups_path, params: { beta_signup: { email: "Petey@hey.com" } }
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("already on the list")
    end
  end

  context "when email is invalid" do
    it "returns an error" do
      post beta_signups_path, params: { beta_signup: { email: "bad" } }
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("double check your email and try again")
    end
  end
end
