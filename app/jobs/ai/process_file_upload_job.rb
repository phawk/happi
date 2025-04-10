class Ai::ProcessFileUploadJob < ApplicationJob
  queue_as :default

  def perform(upload)
    upload.file.open do |file|
      data = Langchain::Loader.new(file.path)&.load&.chunks
      upload.update!(summary: data.map { |chunk| chunk.text }.join("\n\n"), processed_at: Time.current)
    end
  end
end
