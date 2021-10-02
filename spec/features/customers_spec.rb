require "rails_helper"

RSpec.describe "Customers" do
  let(:user) { users(:pete) }

  before { sign_in(user) }

  it "allows manual creation of customers" do
    visit customers_path

    click_on "Manually add"

    fill_in "Name", with: "Frankie Hawkins"
    fill_in "Email", with: "frankie@example.org"
    click_on "Save changes"

    expect(page).to have_content("Customer saved.")
  end

  it "can start a new thread manually", :js do
    visit customer_path(customers(:payhere_alex))

    click_on "New thread"
    fill_in "Subject", with: "Welcome to Happi"
    click_on "Start thread"
    expect(page).to have_content("Welcome to Happi")

    accept_confirm do
      click_on "Archive this thread"
    end

    expect(page).to have_content("Thread archived")
  end
end
