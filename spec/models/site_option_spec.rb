require "rails_helper"

RSpec.describe SiteOption, type: :model do
  describe ".get(key)" do
    it "fetches data when record exists" do
      SiteOption.create!(key: "rates", value: "123")
      expect(SiteOption.get(:rates)).to eq("123")
    end

    it "returns nil when record isnt found" do
      expect(SiteOption.get(:bad)).to be_nil
    end
  end

  describe ".set(key, value)" do
    it "sets new data for given key" do
      SiteOption.set(:rates, "1234")
      expect(SiteOption.get(:rates)).to eq("1234")
    end
  end
end
