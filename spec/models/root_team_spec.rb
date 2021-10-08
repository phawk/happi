require "rails_helper"

RSpec.describe RootTeam, type: :model do
  describe ".load" do
    it "loads Happis own team" do
      expect(described_class.load.name).to eq("Happi")
    end
  end
end
