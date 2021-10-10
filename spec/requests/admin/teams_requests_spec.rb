require "rails_helper"

RSpec.describe Admin::TeamsController, type: :request do
  let(:admin) { users(:pete) }
  let(:unverified_team) { teams(:unverified) }

  before { sign_in(admin) }

  describe "#update" do
    xit "sends team an email when their account is verified" do
      perform_enqueued_jobs do
        patch admin_team_path(unverified_team), params: {
          team: {
            verified_at: 1.day.ago,
          },
        }
        expect(delivered_emails.size).to eq(1)
        expect(last_email.subject).to eq("Your account has been verified")
        expect(last_email.to).to match_array(unverified_team.users.pluck(:email))
        expect(unverified_team.reload.sent_verified_email).to be(true)
      end
    end
  end
end
