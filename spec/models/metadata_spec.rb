require "rails_helper"

RSpec.describe Metadata, type: :model do
  describe ".get(key)" do
    it "fetches data when record exists" do
      Metadata.create!(key: "rates", value: "123")
      expect(Metadata.get(:rates)).to eq("123")
    end

    it "returns nil when record isnt found" do
      expect(Metadata.get(:bad)).to be_nil
    end
  end

  describe ".set(key, value)" do
    it "sets new data for given key" do
      Metadata.set(:rates, "1234")
      expect(Metadata.get(:rates)).to eq("1234")
    end
  end
end
