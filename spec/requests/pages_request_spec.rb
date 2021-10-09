require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /changelog" do
    it "returns http success" do
      get "/changelog"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Happi MVP is live! Yeo!")
    end
  end
end
