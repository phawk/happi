class AddJsonAttributesToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :json_attributes, :jsonb, null: false, default: {}
  end
end
