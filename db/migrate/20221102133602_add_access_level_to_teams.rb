class AddAccessLevelToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :access_level, :string, null: false, default: "standard"
  end
end
