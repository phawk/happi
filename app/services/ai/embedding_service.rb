module Ai
  class EmbeddingService
    class << self
      def embed(content)
        new.embed(content)
      end
    end

    def embed(content)
      client.embeddings(
        parameters: {
          model: "text-embedding-3-small",
          input: content
        }
      ).dig("data", 0, "embedding")
    end

    private

    def client
      @_client ||= OpenAI::Client.new(
        access_token: ENV["OPENAI_API_KEY"],
        log_errors: Rails.env.development? # Highly recommended in development, so you can see what errors OpenAI is returning. Not recommended in production because it could leak private data to your logs.
      )
    end
  end
end
