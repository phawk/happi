require "rails_helper"

RSpec.describe "Customers" do
  let(:user) { users(:pete) }

  before { sign_in(user) }

  it "allows manual creation of customers" do
    visit customers_path

    click_on "Manually add"

    fill_in "Email", with: "frankie@example.org"
    click_on "Save changes"

    expect(page).to have_content("First name can't be blank")

    fill_in "Name", with: "Frankie Hawkins"
    click_on "Save changes"

    expect(page).to have_content("Customer saved.")
  end

  it "can be edited" do
    visit customer_path(customers(:acme_alex))
    click_on "Edit customer"
    fill_in "Name", with: ""
    click_on "Save changes"
    expect(page).to have_content("First name can't be blank")
    fill_in "Name", with: "James Bond"
    click_on "Save changes"
    expect(page).to have_content("James Bond")
    expect(page).not_to have_content("Alex Shaw")
  end

  it "can start a new thread manually" do
    visit customer_path(customers(:acme_alex))

    click_on "New thread"
    fill_in "Subject", with: "Welcome to Happi"
    click_on "Start thread"
    expect(page).to have_content("Welcome to Happi")

    click_on "Archive this thread"

    expect(page).to have_content("Thread archived")
  end
end
