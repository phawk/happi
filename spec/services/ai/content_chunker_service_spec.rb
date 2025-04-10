require "rails_helper"

RSpec.describe Ai::ContentChunkerService, type: :service do
  describe "#call" do
    let(:content) { "This is a test content that needs to be chunked into smaller pieces." }
    let(:service) { described_class.new(content) }

    context "when the service is successful" do
      it "returns a success result with chunks" do
        result = service.call
        expect(result).to be_success
        expect(result.value!).to be_an(Array)
        expect(result.value!.first).to be_a(String)
      end
    end

    context "when an error occurs" do
      it "returns a failure result" do
        allow(service).to receive(:chunk_content).and_raise(StandardError)
        result = service.call
        expect(result).to be_failure
      end
    end
  end
end
