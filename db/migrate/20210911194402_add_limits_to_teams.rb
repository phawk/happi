class AddLimitsToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :available_seats, :integer, null: false, default: 3
    add_column :teams, :messages_limit, :integer, null: false, default: 3000
  end
end
