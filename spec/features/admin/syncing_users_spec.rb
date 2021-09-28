require "rails_helper"

RSpec.describe "Admin: Sync users" do
  let(:admin) { users(:pete) }

  it "creates a customer in Happi from a registered user" do
    sign_in(admin)
    visit admin_root_path
    click_on "Users"
    click_on "janine@example.org"
    click_on "Sync customer"
    expect(page).to have_content "Janine Morrison"
    expect(page).to have_content "New thread"
  end
end
