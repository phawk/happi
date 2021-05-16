class AddSharedSecretToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :shared_secret, :string
    add_column :teams, :publishable_key, :string
    add_index :teams, :shared_secret, unique: true
    add_index :teams, :publishable_key, unique: true
  end
end
