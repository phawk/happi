require "rails_helper"

TeamsFakeCheckoutResponse = Struct.new(:url)

RSpec.describe "Teams", type: :request do
  before { sign_in(users(:pete)) }

  describe "GET /new" do
    it "returns http success" do
      get "/teams/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /" do
    it "creates a new team and defaults plan to free trial" do
      perform_enqueued_jobs do
        post "/teams", params: {
          team: {
            name: "Polywork",
            mail_hash: "polywork",
            time_zone: "Eastern Time (US & Canada)",
            country_code: "US",
          },
        }

        expect(response).to redirect_to(dashboard_path)
        expect(delivered_emails.size).to eq(5)
        expect(delivered_emails.first.subject).to eq("Welcome aboard Polywork!")
        expect(last_email.subject).to eq("Admin alert: A new team signed up")
        expect(Team.last.default_mailbox).to eq("polywork@prioritysupport.net")
        expect(Team.last.plan).to eq("free")
        expect(Team.last.available_seats).to eq(1)
        expect(Team.last.messages_limit).to eq(100)
        expect(Team.last.subscription_status).to eq("trialing")
        expect(Team.last).not_to be_verified
      end
    end

    it "sets the creator to the 'owner' role" do
      post "/teams", params: {
        team: {
          name: "Polywork",
          mail_hash: "polywork",
          time_zone: "Eastern Time (US & Canada)",
          country_code: "US",
        },
      }

      expect(Team.last.team_users.last.role).to eq("owner")
    end

    context "when plan is paid" do
      it "sets pending status and redirects to checkout" do
        allow(BillingService).to receive(:create_checkout) \
          .with(any_args)
          .and_return(TeamsFakeCheckoutResponse.new("https://checkout.fakestripe.com/123"))

        post "/teams", params: {
          team: {
            name: "Polywork",
            mail_hash: "polywork",
            time_zone: "Eastern Time (US & Canada)",
            country_code: "US",
            plan: "basic",
          },
        }

        expect(response).to redirect_to("https://checkout.fakestripe.com/123")
        expect(Team.last.plan).to eq("basic")
        expect(Team.last.available_seats).to eq(3)
        expect(Team.last.messages_limit).to eq(3_000)
        expect(Team.last.subscription_status).to eq("pending")
      end
    end
  end
end
