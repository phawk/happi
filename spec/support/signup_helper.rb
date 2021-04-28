module SignupHelper
  def fill_in_signup_form(args)
    fill_in "user[first_name]", with: args[:first_name]
    fill_in "user[last_name]", with: args[:last_name]
    fill_in "user[email]", with: args[:email]
    fill_in "user[password]", with: args[:password]
    fill_in "user[password_confirmation]", with: args[:password]
    check "user[terms_and_conditions]"
  end
end

RSpec.configure { |config| config.include SignupHelper, type: :feature }
