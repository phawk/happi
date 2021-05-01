class AddTimeZoneToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :time_zone, :string, null: false, default: "Eastern Time (US & Canada)"
    add_column :teams, :country_code, :string, null: false, default: "US"
  end
end
