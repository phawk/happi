class AddFromNameToCustomEmailAddresses < ActiveRecord::Migration[6.1]
  def change
    add_column :custom_email_addresses, :from_name, :string
    add_column :messages, :from_address, :string
  end
end
