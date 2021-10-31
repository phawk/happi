require "rails_helper"

RSpec.describe "Auth", type: :request do
  it "returns users name when signed in" do
    sign_in(users(:pete))
    get "/auth/check"
    expect(response).to have_http_status(:ok)
    expect(json[:signed_in]).to be(true)
    expect(json[:first_name]).to eq("Pete")
  end

  it "returns 401 when not signed in" do
    get "/auth/check"
    expect(response).to have_http_status(:ok)
    expect(json[:signed_in]).to be(false)
  end
end
