require "rails_helper"

RSpec.describe "TeamInvites", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get team_invite_path(id: teams(:payhere).invite_code)
      expect(response).to have_http_status(:success)
    end
  end
end
