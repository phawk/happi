class AddMessageNotificationsToTeamsUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :teams_users, :message_notifications, :boolean, null: false, default: true
    add_column :teams_users, :role, :string, null: false, default: "member"
  end
end
