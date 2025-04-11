class AddFirstCustomerMessageIdToReplyStatistics < ActiveRecord::Migration[7.2]
  def change
    add_reference :reply_statistics, :first_customer_message, null: false, foreign_key: { to_table: :messages }
  end
end
