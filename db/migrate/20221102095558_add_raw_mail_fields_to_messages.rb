class AddRawMailFieldsToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :original_html, :text
    add_column :messages, :action_mailbox_id, :bigint
  end
end
