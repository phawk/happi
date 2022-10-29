require "rails_helper"

FakeCheckoutResponse = Struct.new(:url)

RSpec.describe "TeamUsers", type: :request do
  let(:user) { users(:pete) }
  let(:team_user) { users(:pete).team_users.find_by(team: user.team) }

  before { sign_in(user) }

  describe "PUT /team_users/:id" do
    it "allows updating the message_notifications" do
      put "/team_users/#{team_user.id}", params: {
        team_user: {
          message_notifications: false,
        },
      }

      expect(team_user.reload.message_notifications).to be(false)
      expect(response).to redirect_to(team_settings_path)
    end
  end
end
