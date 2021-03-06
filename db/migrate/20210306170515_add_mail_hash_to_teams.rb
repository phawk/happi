class AddMailHashToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :mail_hash, :string, null: false, default: ""
    add_index :teams, :mail_hash, unique: true
  end
end
