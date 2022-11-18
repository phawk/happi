class CreateBlockedDomains < ActiveRecord::Migration[7.0]
  def change
    create_table :blocked_domains do |t|
      t.references :team, null: false, foreign_key: true
      t.string :domain, null: false

      t.timestamps
    end
  end
end
