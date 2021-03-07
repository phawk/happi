class CreateCustomEmailAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_email_addresses do |t|
      t.string :email, null: false
      t.references :team, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
