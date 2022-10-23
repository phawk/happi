require "rails_helper"

RSpec.describe Admin::TeamsController, type: :request do
  let(:admin) { users(:pete) }
  let(:unverified_team) { teams(:unverified) }

  before { sign_in(admin) }

  describe "#verified_email" do
    it "sends team an email when their account is verified" do
      unverified_team.update(verified_at: 1.day.ago)

      perform_enqueued_jobs do
        post admin_team_verified_email_path(unverified_team)
        expect(delivered_emails.size).to eq(1)
        expect(last_email.subject).to eq("Your account has been verified")
        expect(last_email.to).to match_array(unverified_team.users.pluck(:email))
        expect(unverified_team.reload.sent_verified_email).to be(true)
        expect(response).to redirect_to(admin_team_path(unverified_team))
        follow_redirect!
        expect(response.body).to include("Verified email sent")
      end
    end

    it "shows an error if the team isnt verified" do
      perform_enqueued_jobs do
        post admin_team_verified_email_path(unverified_team)
        expect(delivered_emails.size).to eq(0)
        expect(unverified_team.reload.sent_verified_email).to be_falsy
        expect(response).to redirect_to(admin_team_path(unverified_team))
        follow_redirect!
        expect(response.body).to include("This team is not verified")
      end
    end
  end
end
