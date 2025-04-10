require "rails_helper"
require "vcr_helper"

RSpec.describe Ai::Tools::KnowledgeBaseTool do
  let(:agent) { SpamDetectAgent.new(message: messages(:acme_alex_stripe_msg_1), team: teams(:acme)) }
  let(:tool) { described_class.new(agent: agent) }

  describe "#search" do
    it "returns a json response", :vcr do
      result = tool.search(query: "test")
      result = JSON.parse(result)
      expect(result["data"]).to be_a(Array)
    end
  end
end
