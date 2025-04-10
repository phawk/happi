class AddVectorizedAtToKnowledgeBaseFileUploads < ActiveRecord::Migration[7.2]
  def change
    add_column :knowledge_base_file_uploads, :vectorized_at, :datetime
  end
end
