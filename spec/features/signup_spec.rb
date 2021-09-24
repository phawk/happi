require "rails_helper"

RSpec.describe "Signing up" do
  it "allows signup when user doesnt have an account" do
    visit new_user_registration_path

    fill_in_signup_form(
      first_name: "Joe",
      last_name: "Blogs",
      email: "joe.blogs@example.org",
      password: "hunter212",
      password_confirmation: "hunter212"
    )

    click_on "Get started"

    fill_in_team_form(
      name: "Darktrace",
      country: "United Kingdom",
    )

    click_on "Create team"

    expect(page).to have_content("You haven’t received any messages yet")
  end
end
