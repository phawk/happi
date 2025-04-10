module Ai
  class FileUploadVectorizerService < ApplicationService
    option :file_upload

    delegate :user, :team, to: :file_upload

    def call
      chunks = chunk_content
      embeddings = generate_embeddings(chunks)
      store_embeddings(embeddings, chunks)
      Success(embeddings)
    rescue => e
      Failure(e)
    end

    private

    def chunk_content
      content = @file_upload.summary
      Ai::ContentChunkerService.new(content).call.value_or { |failure| raise failure }
    end

    def generate_embeddings(chunks)
      chunks.map { |chunk| Ai::EmbeddingService.embed(chunk) }
    end

    def store_embeddings(embeddings, chunks)
      embeddings.each_with_index do |embedding, index|
        @file_upload.embeddings.create!(
          user: user,
          team: team,
          content: chunks[index],
          vectors: embedding
        )
      end
    end
  end
end
