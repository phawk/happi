require "rails_helper"

RSpec.describe "Customers", type: :request do
  let(:alex) { customers(:payhere_alex) }

  before { sign_in(users(:pete)) }

  describe "GET /" do
    it "returns http success" do
      get "/customers"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /customers/:id/block" do
    it "sets customer as blocked" do
      post block_customer_path(alex)

      expect(response).to redirect_to(customer_path(alex))
      follow_redirect!
      expect(response.body).to include("has been blocked")
    end
  end

  describe "POST /customers/:id/unblock" do
    it "sets customer as unblocked" do
      alex.update(blocked: true)

      post unblock_customer_path(alex)

      expect(response).to redirect_to(customer_path(alex))
      follow_redirect!
      expect(response.body).to include("Now receiving")
    end
  end
end
