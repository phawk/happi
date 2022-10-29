class AddSlackFieldsToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :slack_webhook_url, :string
    add_column :teams, :slack_channel_name, :string
  end
end
