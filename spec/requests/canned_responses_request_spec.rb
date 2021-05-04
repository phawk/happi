require 'rails_helper'

RSpec.describe "CannedResponses", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get "/canned_responses/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/canned_responses/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
