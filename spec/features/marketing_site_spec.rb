require "rails_helper"

RSpec.describe "Marketing site" do
  it "loads without errors" do
    visit root_path
    expect(page).to have_content "Simple customer support"

    click_on "Get started free"
    expect(page).to have_content "Choose your plan"

    first(:link, "Get started").click
    expect(page).to have_content "Create your account"
  end
end
