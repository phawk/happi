class AddBlockedToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :blocked, :boolean, null: false, default: false
  end
end
