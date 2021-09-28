require "rails_helper"

RSpec.describe SyncUserToHappi, type: :modal do
  it "creates a customer within Happi" do
    expect do
      customer = described_class.sync(users(:janine))

      expect(customer.team.name).to eq("Happi")
      expect(customer.name).to eq("Janine Morrison")
      expect(customer.email).to eq("janine@example.org")
      expect(customer.company).to eq("CoreFX")
    end.to change(Customer, :count).by(1)
  end

  it "updates the customer when they exist" do
    described_class.sync(users(:janine))

    expect do
      described_class.sync(users(:janine))
    end.not_to change(Customer, :count)
  end
end
