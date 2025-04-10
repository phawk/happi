module Ai
  class ContentChunkerService < ApplicationService
    DEFAULT_CHUNK_SIZE = 500  # Define the size of each chunk
    DEFAULT_OVERLAP_SIZE = 50  # Define the size of overlap between chunks

    option :content
    option :chunk_size, default: -> { DEFAULT_CHUNK_SIZE }
    option :overlap_size, default: -> { DEFAULT_OVERLAP_SIZE }

    def call
      Success(chunk_content)
    rescue => e
      Failure(e)
    end

    private

    def chunk_content
      paragraphs = @content.split(/\n+/)
      chunks = []

      paragraphs.each do |paragraph|
        if paragraph.length > chunk_size
          chunks.concat(split_paragraph(paragraph))
        else
          chunks << paragraph
        end
      end

      chunks
    end

    def split_paragraph(paragraph)
      sentences = paragraph.split(/(?<=[.!?])\s+/)
      chunks = []
      current_chunk = ""

      sentences.each do |sentence|
        if (current_chunk + sentence).length > chunk_size
          chunks << current_chunk.strip
          current_chunk = sentence
        else
          current_chunk += " " + sentence
        end
      end

      chunks << current_chunk.strip unless current_chunk.empty?
      chunks
    end
  end
end
