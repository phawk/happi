require "rails_helper"

RSpec.describe Customer, type: :model do
  let(:team) { teams(:payhere) }
  let(:alex) { customers(:payhere_alex) }

  it { is_expected.to belong_to(:team) }
  it { is_expected.to have_many(:message_threads) }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:email) }

  describe ".upsert_by_jwt" do
    it "creates new customer when they don't exist" do
      jwt = JWT.encode({ first_name: "Pedro", last_name: "Gonzalles", email: "pedro@hey.com" }, team.shared_secret,
        "HS512")

      cus = Customer.upsert_by_jwt(jwt, team)

      expect(cus.name.familiar).to eq("Pedro G.")
      expect(cus.email).to eq("pedro@hey.com")
    end

    it "updates customer when they already exist" do
      jwt = JWT.encode({ first_name: "Alexander", last_name: "Shaw", email: "alex.shaw09@hotmail.com" },
        team.shared_secret, "HS512")

      cus = Customer.upsert_by_jwt(jwt, team)

      expect(cus.name.familiar).to eq("Alexander S.")
      expect(cus.email).to eq("alex.shaw09@hotmail.com")
    end
  end

  describe "#as_jwt" do
    it "returns customer data as JWT" do
      jwt = alex.as_jwt

      cus = Customer.upsert_by_jwt(jwt, team)

      expect(cus.name.first).to eq("Alex")
    end
  end
end
