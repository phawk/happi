require "rails_helper"

RSpec.describe "Canned responses" do
  let(:user) { users(:pete) }

  before { sign_in(user) }

  it "allows crud for canned response" do
    visit canned_responses_settings_path

    click_on "New canned response"
    fill_in "Label", with: "Response #1"
    click_on "Save changes"
    expect(page).to have_content("Response #1")

    click_on "Edit"
    fill_in "Label", with: "Response #100"
    click_on "Save changes"
    expect(page).to have_content("Response #100")

    click_on "Delete"
    expect(page).to have_content("Canned response deleted")
    expect(page).not_to have_content("Response #100")
  end
end
