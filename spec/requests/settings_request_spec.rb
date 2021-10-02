require "rails_helper"

RSpec.describe "Settings", type: :request do
  before { sign_in(users(:pete)) }

  describe "GET /settings" do
    it "returns http success" do
      get settings_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /settings/team" do
    it "returns http success" do
      get team_settings_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /settings/emails" do
    it "returns http success" do
      get emails_settings_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /settings/canned_responses" do
    it "returns http success" do
      get canned_responses_settings_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /settings/widget" do
    it "returns http success" do
      get widget_settings_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /settings/billing" do
    it "returns http success" do
      get billing_settings_path
      expect(response).to have_http_status(:success)
    end
  end
end
