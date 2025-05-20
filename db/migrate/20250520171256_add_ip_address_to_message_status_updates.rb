class AddIpAddressToMessageStatusUpdates < ActiveRecord::Migration[7.2]
  def change
    add_column :message_status_updates, :ip_address, :string
    add_column :message_status_updates, :user_agent, :string
  end
end
