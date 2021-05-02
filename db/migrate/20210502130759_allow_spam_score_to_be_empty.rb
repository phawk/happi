class AllowSpamScoreToBeEmpty < ActiveRecord::Migration[6.1]
  def change
    change_column_null :messages, :spam_score, true
    change_column_default :messages, :spam_score, from: 0.0, to: nil
  end
end
