require "rails_helper"

FakeCheckoutResponse = Struct.new(:url)

RSpec.describe "TeamUsers", type: :request do
  let(:team) { teams(:acme) }
  let(:user) { users(:pete) }
  let(:team_user) { team.team_users.find_by!(user: user) }

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

  describe "DELETE /team_users/:id" do
    let(:second_user) { users(:scott) }
    let(:user_without_team) { users(:user_without_team) }

    it "removes the user from the team" do
      team.add_user(second_user)
      team_user = team.team_users.find_by!(user: second_user)

      expect do
        delete "/team_users/#{team_user.id}"
        expect(response).to redirect_to team_settings_path
      end.to change(TeamUser, :count).by(-1)

      expect(second_user.reload.teams.count).to be > 0
    end

    it "deletes the user if they have no other teams" do
      team.add_user(user_without_team)
      team_user = team.team_users.find_by!(user: user_without_team)

      expect do
        delete "/team_users/#{team_user.id}"
        expect(response).to redirect_to team_settings_path
      end.to change(User, :count).by(-1)
    end

    it "stops you from deleting yourself" do
      expect do
        delete "/team_users/#{team_user.id}"
        expect(response).to redirect_to team_settings_path
      end.not_to change(TeamUser, :count)
    end
  end
end
