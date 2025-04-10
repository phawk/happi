require "rails_helper"

RSpec.describe Ai::ContentChunkerService, type: :service do
  describe "#call" do
    let(:content) { "This is a test content. It needs to be chunked into smaller pieces.\n\nHere is another paragraph that is quite long and might need to be split further. It contains multiple sentences to test the splitting logic. This sentence is added to ensure the paragraph exceeds the chunk size." }
    let(:service) { described_class.new(content:, chunk_size: 100, overlap_size: 20) }

    context "when the service is successful" do
      it "returns a success result with chunks" do
        result = service.call
        expect(result).to be_success
        expect(result.value!).to be_an(Array)
        expect(result.value!.first).to be_a(String)
        expect(result.value!.length).to be > 1
      end

      it "splits long paragraphs by punctuation and includes overlap" do
        result = service.call
        chunks = result.value!

        expect(chunks.any? { |chunk| chunk.start_with?("This is a test content. It needs") }).to be true
        expect(chunks.any? { |chunk| chunk.start_with?("into smaller pieces. Here is another paragraph") }).to be true
        expect(chunks.any? { |chunk| chunk.start_with?("to be split further. It contains multiple sentences") }).to be true
        expect(chunks.any? { |chunk| chunk.start_with?("the splitting logic. This sentence is added") }).to be true
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
