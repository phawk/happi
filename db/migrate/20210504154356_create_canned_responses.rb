class CreateCannedResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :canned_responses do |t|
      t.references :team, null: false, foreign_key: true
      t.string :label, null: false

      t.timestamps
    end
  end
end
