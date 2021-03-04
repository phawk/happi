require "rails_helper"

RSpec.describe "Customers", type: :request do
  before { sign_in(users(:pete)) }

  describe "GET /" do
    it "returns http success" do
      get "/customers"
      expect(response).to have_http_status(:success)
    end
  end
end
