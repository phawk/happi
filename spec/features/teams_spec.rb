require "rails_helper"

RSpec.describe "Teams" do
  let(:user) { users(:pete) }

  before { sign_in(user) }

  it "allows switching between teams" do
    visit dashboard_path
    expect(page).to have_content "Payhere"
    click_on "change"

    within ".rounded-3xl" do
      click_on "Happi"
    end

    expect(page).to have_content "Happi"
    expect(page).not_to have_content "Payhere"
  end
end
