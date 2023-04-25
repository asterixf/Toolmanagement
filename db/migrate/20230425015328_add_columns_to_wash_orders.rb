class AddColumnsToWashOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :wash_orders, :active, :integer
    add_column :wash_orders, :blocked, :integer
    add_column :wash_orders, :damaged, :integer
  end
end
