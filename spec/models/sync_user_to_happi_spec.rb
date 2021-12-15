require "rails_helper"

RSpec.describe SyncUserToHappi, type: :modal do
  before { Current.team = teams(:happi) }
  it "creates a customer within Happi" do
    expect do
      customer = described_class.sync(users(:janine))

      expect(customer.team.name).to eq("Happi")
      expect(customer.name).to eq("Janine Morrison")
      expect(customer.email).to eq("core-fx-123@prioritysupport.net")
      expect(customer.company).to eq("CoreFX")
    end.to change(Customer, :count).by(1)
  end

  it "updates the customer when they exist" do
    described_class.sync(users(:janine))

    expect do
      described_class.sync(users(:janine))
    end.not_to change(Customer, :count)
  end

  it "creates a new customer if they exist on a different team" do
    other_team = teams(:nine)
    Current.team = other_team
    existing_customer = Customer.create(
      email: "core-fx-123@prioritysupport.net",
      first_name: "Janine"
    )

    Current.team = teams(:happi)
    expect do
      new_customer = described_class.sync(users(:janine))
      expect(new_customer).not_to eq(existing_customer)
    end.to change(Customer, :count).by(1)
  end
end
