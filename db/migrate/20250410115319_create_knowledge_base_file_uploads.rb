class CreateKnowledgeBaseFileUploads < ActiveRecord::Migration[7.2]
  def change
    create_table :knowledge_base_file_uploads do |t|
      t.references :user, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.text :summary
      t.datetime :processed_at

      t.timestamps
    end
  end
end
