require "rails_helper"

RSpec.describe "Admin: Sync users" do
  it "visits all the admin pages without issue" do
    visit documentation_root_path
    expect(page).to have_content "Getting started"

    click_nav "Custom email addresses"
    click_nav "Forwarding mail to Happi"
    # click_nav "Contact forms"
    click_nav "Installation"
    click_nav "Prefill user data"
    click_nav "Full configuration"
  end

  def click_nav(text)
    first(:link, text).click
  end
end
