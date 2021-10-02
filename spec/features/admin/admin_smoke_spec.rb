require "rails_helper"

RSpec.describe "Admin: Sync users" do
  let(:admin) { users(:pete) }
  let(:non_admin) { users(:janine) }

  it "visits all the admin pages without issue" do
    sign_in(admin)
    visit admin_root_path
    click_on "Users"
    click_on "Custom Email Addresses"
    click_on "Beta Signups"
  end

  it "kicks out non-admins" do
    sign_in(non_admin)
    visit admin_root_path
    expect(page).to have_content "You are not an admin"
  end
end
