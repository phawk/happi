class AddReplyToToMessageThreads < ActiveRecord::Migration[6.1]
  def change
    add_column :message_threads, :reply_to, :string
  end
end
