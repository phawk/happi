class AddSpamFieldsToTeams < ActiveRecord::Migration[7.2]
  def change
    add_column :teams, :spam_prompt, :text
    add_column :teams, :spam_threshold, :decimal, precision: 10, scale: 2, default: 5.0
  end
end
