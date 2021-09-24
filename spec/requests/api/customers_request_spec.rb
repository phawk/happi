require "rails_helper"

RSpec.describe Api::CustomersController, type: :request do
  let(:team) { teams(:payhere) }

  describe "POST /api/:key/customers" do
    it "creates new customers" do
      post "/api/#{team.publishable_key}/customers", params: {
        first_name: "Fred",
        last_name: "Wilks",
        email: "freddy42@hotmail.com",
      }

      expect(response).to have_http_status(:created)

      expect(json[:jwt]).not_to be_nil
    end

    it "updates existing customers" do
      post "/api/#{team.publishable_key}/customers", params: {
        first_name: "Alex",
        last_name: "Shaw",
        email: "alex.shaw09@hotmail.com",
      }

      expect(response).to have_http_status(:ok)

      expect(json[:jwt]).not_to be_nil
    end

    it "returns validation errors" do
      post "/api/#{team.publishable_key}/customers", params: {
        first_name: "Alex",
        email: "alex.shaw09",
      }

      expect(response).to have_http_status(:unprocessable_entity)

      expect(json[:error]).to eq("Customer validation failed")
    end
  end
end
