require "rails_helper"

RSpec.feature "Signing up" do
  scenario "it allows signup when user doesnt have an account" do
    visit new_user_registration_path

    fill_in_signup_form(
      first_name: "Joe",
      last_name: "Blogs",
      email: "joe.blogs@example.org",
      password: "hunter212",
      password_confirmation: "hunter212"
    )

    check "user[terms_and_conditions]"

    click_button "Get started"

    expect(page).to have_content("Set up your team")
  end
end
