require "rails_helper"

RSpec.describe Billing::SubscriptionsController, type: :request do
  before { sign_in(users(:pete)) }

  describe "GET /billing/subscriptions" do
    it "renders available subscriptions" do
      get billing_subscriptions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Individual")
      expect(response.body).to include("Basic")
      expect(response.body).to include("Business")
    end
  end
end
