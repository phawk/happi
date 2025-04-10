class CreateEmbeddings < ActiveRecord::Migration[7.2]
  def change
    create_table :embeddings do |t|
      t.references :object, polymorphic: true, null: false
      t.vector :vectors, limit: 1536
      t.text :content, null: false
      t.references :user, null: false
      t.references :team, null: false

      t.timestamps
    end
  end
end
