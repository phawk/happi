class CreateMessageStatusUpdates < ActiveRecord::Migration[7.2]
  def change
    create_table :message_status_updates do |t|
      t.references :message, null: false, foreign_key: true
      t.string :value
      t.json :data

      t.timestamps
    end
  end
end
