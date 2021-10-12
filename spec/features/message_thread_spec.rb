require "rails_helper"

RSpec.describe "Message thread", type: :feature do
  let(:user) { users(:pete) }

  before { sign_in(user) }

  describe "when creating" do
    it "sets the subject and reply to" do
      visit dashboard_path

      click_on "Customers"
      click_on "alex.shaw09@hotmail.com"
      click_on "New thread"

      fill_in "Subject", with: "Welcome aboard"
      select "Payhere Support <support@payhere.co>", from: "Reply to"

      click_on "Start thread"

      expect(page).to have_content "Thread settings"
      expect(page).to have_content("Receiving emails from\nPayhere Support <support@payhere.co>")
    end
  end
end
