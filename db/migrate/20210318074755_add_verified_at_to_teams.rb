class AddVerifiedAtToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :verified_at, :datetime
    add_column :teams, :invite_code, :string
    add_index :teams, :invite_code, unique: true
  end
end
