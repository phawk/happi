require "rails_helper"

RSpec.describe "CustomEmailAddresses", type: :request do
  before { sign_in(users(:pete)) }

  describe "#create" do
    before do
      perform_enqueued_jobs do
        post "/custom_email_addresses", params: {
          custom_email_address: {
            email: "help@acme.com",
            from_name: "ACME Help",
          },
        }
      end
    end

    it "redirects back to settings" do
      expect(response).to redirect_to(emails_settings_path)
    end

    it "creates an unconfirmed email address" do
      email = CustomEmailAddress.last
      expect(email.from_name).to eq("ACME Help")
      expect(email.email).to eq("help@acme.com")
    end

    it "notifies the team and admins" do
      expect(delivered_emails.size).to eq(2)
      expect(delivered_emails.first.subject).to eq("Your custom email is awaiting approval")
      expect(last_email.subject).to eq("Admin alert: Custom email needs confirmed!")
    end
  end

  describe "#destroy" do
    let(:email) { custom_email_addresses(:acme_unconfirmed) }

    it "deletes a custom email address" do
      expect do
        delete "/custom_email_addresses/#{email.id}"
        expect(response).to redirect_to(emails_settings_path)
      end.to change(CustomEmailAddress, :count).by(-1)
    end
  end
end
