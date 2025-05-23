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

  desc "Process all message threads"
  task process_message_threads: :environment do
    Team.find_each do |team|
      puts "Processing team #{team.name}..."

      team.allowed_threads.ham(team).find_each do |message_thread|
        puts "Processing message thread #{message_thread.id}..."
        ProcessMessageThreadReplyJob.new.perform(message_thread)
      end
    end
  end
end
