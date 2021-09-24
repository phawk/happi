class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.references :team, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.string :company
      t.string :phone
      t.string :country_code
      t.string :location
      t.datetime :last_contacted_at

      t.timestamps
    end

    add_index :customers, :email
    add_index :customers, %i[email team_id], unique: true
  end
end
