class KnowledgeBaseController < ApplicationController
  def index
    @file_uploads = current_team.file_uploads.order(created_at: :desc)
    @new_file_upload = current_team.file_uploads.new
  end

  def create
    @file_upload = current_team.file_uploads.build(file_upload_params)
    @file_upload.user = current_user

    if @file_upload.save
      Ai::ProcessFileUploadJob.perform_later(@file_upload)
      redirect_to knowledge_base_index_path, notice: "File uploaded successfully and is being processed."
    else
      @file_uploads = current_team.file_uploads.order(created_at: :desc)
      @new_file_upload = @file_upload # Preserve the failed upload object for the form
      render :index, status: :unprocessable_entity
    end
  end

  private

  def file_upload_params
    params.require(:knowledge_base_file_upload).permit(:file)
  end
end
