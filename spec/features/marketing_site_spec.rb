require "rails_helper"

RSpec.describe "Marketing site" do
  it "loads without errors" do
    visit root_path

    expect(page).to have_content("Better customer engagement for startups")

    click_on("Get started free")

    expect(page).to have_content("Choose your plan")

    first(:link, "Get started").click

    expect(page).to have_content("Create your account")
  end
end
