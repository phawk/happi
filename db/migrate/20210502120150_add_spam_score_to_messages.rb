class AddSpamScoreToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :spam_score, :decimal, precision: 8, scale: 2, null: false, default: 0
  end
end
