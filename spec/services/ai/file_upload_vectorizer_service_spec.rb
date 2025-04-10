require "rails_helper"

RSpec.describe Ai::FileUploadVectorizerService, type: :service do
  let(:user) { users(:pete) }
  let(:team) { teams(:acme) }

  describe "#call" do
    let(:file_upload) do
      team.file_uploads.create!(
        user: user,
        file: fixture_file_upload("spec/fixtures/files/test.pdf", "application/pdf"),
        summary: "This is a test content for vectorization."
      )
    end
    let(:service) { described_class.new(file_upload: file_upload) }

    context "when the service is successful" do
      it "returns a success result with embeddings" do
        allow_any_instance_of(Ai::ContentChunkerService).to receive(:call).and_return(Dry::Monads::Result::Success.new(["chunk1", "chunk2"]))
        allow(Ai::EmbeddingService).to receive(:embed).and_return(Array.new(1536) { |i| (i + 1.0) / 1536 })

        expect do
          result = service.call
          expect(result).to be_success
          expect(result.value!).to be_an(Array)
          expect(result.value!.first).to be_an(Array)
        end.to change(Embedding, :count).by(2)
      end
    end

    context "when an error occurs" do
      it "returns a failure result" do
        allow_any_instance_of(Ai::ContentChunkerService).to receive(:call).and_raise(StandardError)
        result = service.call
        expect(result).to be_failure
      end
    end
  end
end
