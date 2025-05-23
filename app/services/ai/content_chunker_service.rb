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

      add_overlap(chunks)
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

    # Add overlap to each chunk by concatenating previous and following chunks
    # without modifying the original chunks array

    def add_overlap(chunks)
      overlapped_chunks = []

      chunks.each_with_index do |chunk, index|
        previous_overlap = chunks[0...index].join(' ')[-overlap_size..-1] || ""
        following_overlap = chunks[(index + 1)..-1].join(' ')[0...overlap_size] || ""

        overlapped_chunk = "#{previous_overlap} #{chunk} #{following_overlap}".strip
        overlapped_chunks << overlapped_chunk
      end

      overlapped_chunks
    end
  end
end
