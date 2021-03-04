class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :message_thread, null: false, foreign_key: true
      t.string :sender_type, null: false
      t.bigint :sender_id, null: false
      t.boolean :internal, null: false, default: false
      t.text :body, null: false, default: ""
      t.text :raw, null: false, default: ""
      t.string :status, null: false, default: "pending"
      t.jsonb :metadata, default: {}, null: false

      t.timestamps
    end
  end
end
