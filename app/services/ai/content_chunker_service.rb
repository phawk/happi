module Ai
  class ContentChunkerService < ApplicationService
    CHUNK_SIZE = 500  # Define the size of each chunk

    def initialize(content)
      @content = content
    end

    def call
      Success(chunk_content)
    rescue => e
      Failure(e)
    end

    private

    def chunk_content
      @content.scan(/.{1,#{CHUNK_SIZE}}(?:\s|$)/).map(&:strip)
    end
  end
end
