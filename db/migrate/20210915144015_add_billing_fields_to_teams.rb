class AddBillingFieldsToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :stripe_customer_id, :string
    add_column :teams, :stripe_subscription_id, :string
    add_column :teams, :subscription_status, :string, null: false, default: "pending"
  end
end
