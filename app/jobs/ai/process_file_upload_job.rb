class Ai::ProcessFileUploadJob < ApplicationJob
  queue_as :default

  def perform(upload)
    upload.file.open do |file|
      data = Langchain::Loader.new(file.path)&.load&.chunks
      upload.update!(summary: data.map { |chunk| chunk.text }.join("\n\n"), processed_at: Time.current)
    end

    vectorizer_service = Ai::FileUploadVectorizerService.new(file_upload: upload.reload)
    result = vectorizer_service.call

    if result.success?
      upload.update(vectorized_at: Time.current)
    else
      # Handle failure case, e.g., log error or retry
    end
  end
end
