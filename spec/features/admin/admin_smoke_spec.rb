require "rails_helper"

RSpec.describe "Admin: Sync users" do
  let(:admin) { users(:pete) }

  it "visits all the admin pages without issue" do
    sign_in(admin)
    visit admin_root_path
    click_on "Users"
    click_on "Custom Email Addresses"
    click_on "Beta Signups"
  end
end
