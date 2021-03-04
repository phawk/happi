require "rails_helper"

RSpec.describe "Teams", type: :request do
  before { sign_in(users(:pete)) }

  describe "GET /new" do
    it "returns http success" do
      get "/teams/new"
      expect(response).to have_http_status(:success)
    end
  end
end
