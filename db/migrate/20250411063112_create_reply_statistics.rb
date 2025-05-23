class CreateReplyStatistics < ActiveRecord::Migration[7.2]
  def change
    create_table :reply_statistics do |t|
      t.references :message_thread, null: false, foreign_key: true
      t.text :message_ids, array: true, default: [], null: false
      t.text :reply_ids, array: true, default: [], null: false
      t.references :team, null: false, foreign_key: true
      t.integer :time_to_reply, null: false

      t.timestamps
    end
  end
end
