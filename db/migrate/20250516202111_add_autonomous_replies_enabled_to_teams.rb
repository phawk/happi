class AddAutonomousRepliesEnabledToTeams < ActiveRecord::Migration[7.2]
  def change
    add_column :teams, :autonomous_replies_enabled, :boolean, null: false, default: false
  end
end
