module SignupHelper
  def fill_in_signup_form(args)
    fill_in "user[first_name]", with: args[:first_name]
    fill_in "user[last_name]", with: args[:last_name]
    fill_in "user[email]", with: args[:email]
    fill_in "user[password]", with: args[:password]
    fill_in "user[password_confirmation]", with: args[:password]
    check "user[terms_and_conditions]"
  end

  def fill_in_team_form(args)
    expect(page).to have_content("Set up your team")

    fill_in "team[name]", with: args[:name]
    fill_in "team[mail_hash]", with: args[:mail_hash]
    select(args[:country], from: "team[country_code]")
    select(args[:time_zone], from: "team[time_zone]") if args[:time_zone].present?
    select(args[:plan], from: "team[plan]") if args[:plan].present?
  end
end

RSpec.configure { |config| config.include SignupHelper, type: :feature }
