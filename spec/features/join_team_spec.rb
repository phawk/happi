require "rails_helper"

RSpec.describe "Joining teams" do
  let(:team) { teams(:acme) }

  it "allows signup when user doesnt have an account" do
    visit join_team_path(code: team.invite_code)

    fill_in_signup_form(
      first_name: "Joe",
      last_name: "Blogs",
      email: "joe.blogs@example.org",
      password: "hunter212",
      password_confirmation: "hunter212"
    )

    click_button "Accept invite"

    expect(page).to have_content("signed up successfully")
  end

  it "prompts user to join the team if they are signed in" do
    sign_in(users(:scott))

    visit join_team_path(code: team.invite_code)

    click_button "Join team"

    expect(page).to have_content("You are now a member of ACME Corp")
  end
end
