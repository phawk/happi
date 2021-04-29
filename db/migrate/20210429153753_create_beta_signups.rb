class CreateBetaSignups < ActiveRecord::Migration[6.1]
  def change
    create_table :beta_signups do |t|
      t.string :email, null: false
      t.datetime :signed_up_at
      t.references :team

      t.timestamps
    end
  end
end
