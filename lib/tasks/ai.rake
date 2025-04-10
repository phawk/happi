namespace :ai do
  desc "Process all file uploads"
  task vectorize_file_uploads: :environment do
    KnowledgeBase::FileUpload.with_summary.where(vectorized_at: nil).find_each do |upload|
      vectorizer_service = Ai::FileUploadVectorizerService.new(file_upload: upload)
      result = vectorizer_service.call

      if result.success?
        upload.update(vectorized_at: Time.current)
      else
        # Handle failure case, e.g., log error or retry
      end
    end
  end
end
