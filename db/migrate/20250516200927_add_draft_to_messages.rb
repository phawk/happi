class AddDraftToMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :messages, :draft, :boolean, null: false, default: false
    add_column :messages, :ai_agent, :boolean, null: false, default: false
  end
end
