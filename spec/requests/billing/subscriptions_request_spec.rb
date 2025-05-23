require "rails_helper"

RSpec.describe Billing::SubscriptionsController, type: :request do
  before { sign_in(users(:pete)) }

  describe "GET /billing/subscriptions" do
    it "renders available subscriptions" do
      get billing_subscriptions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Starter")
      expect(response.body).to include("Growth")
      expect(response.body).to include("Scale")
    end
  end

  describe "GET /billing/success" do
    it "renders thank you message" do
      get billing_success_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Thanks")
    end
  end
end
