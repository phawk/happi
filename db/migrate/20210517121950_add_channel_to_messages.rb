class AddChannelToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :channel, :string, null: false, default: "email"
  end
end
