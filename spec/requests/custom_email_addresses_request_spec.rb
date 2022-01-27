require "rails_helper"

RSpec.describe "CustomEmailAddresses", type: :request do
  before { sign_in(users(:pete)) }

  describe "#create" do
    before do
      post "/custom_email_addresses", params: {
        custom_email_address: {
          email: "help@acme.com",
          from_name: "ACME Help",
        },
      }
    end

    it "redirects back to settings" do
      expect(response).to redirect_to(emails_settings_path)
    end

    it "creates an unconfirmed email address" do
      email = CustomEmailAddress.last
      expect(email.from_name).to eq("ACME Help")
      expect(email.email).to eq("help@acme.com")
    end
  end

  describe "#destroy" do
    let(:email) { custom_email_addresses(:acme_unconfirmed) }

    it "deletes a custom email address" do
      expect do
        delete "/custom_email_addresses/#{email.id}"
        expect(response).to redirect_to(emails_settings_path)
      end.to change { CustomEmailAddress.count }.by(-1)
    end
  end
end
