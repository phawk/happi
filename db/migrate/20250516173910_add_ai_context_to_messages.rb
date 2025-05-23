class AddAiContextToMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :messages, :ai_context, :text
  end
end
