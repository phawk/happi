require "rails_helper"

RSpec.describe "Admin masquerading as other users" do
  let(:admin) { users(:pete) }

  it "can login as another user" do
    sign_in(admin)
    visit admin_users_path
    click_on "janine@example.org"
    click_on "Login as"
    expect(page).to have_current_path("/threads")
    expect(page).to have_content "Hey Janine M."
  end
end
