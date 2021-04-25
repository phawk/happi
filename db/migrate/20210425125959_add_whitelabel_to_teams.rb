class AddWhitelabelToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :whitelabel, :boolean, null: false, default: false
  end
end
