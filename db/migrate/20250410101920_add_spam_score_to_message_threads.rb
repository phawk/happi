class AddSpamScoreToMessageThreads < ActiveRecord::Migration[7.2]
  def change
    add_column :message_threads, :spam_score, :decimal, precision: 10, scale: 2
  end
end
