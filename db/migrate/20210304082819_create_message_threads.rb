class CreateMessageThreads < ActiveRecord::Migration[6.1]
  def change
    create_table :message_threads do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.string :subject, null: false, default: ""
      t.string :status, null: false, default: "open"
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
