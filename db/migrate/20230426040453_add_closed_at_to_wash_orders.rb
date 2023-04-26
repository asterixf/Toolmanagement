class AddClosedAtToWashOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :wash_orders, :washing_time
    add_column :wash_orders, :wash_time, :datetime
    add_column :wash_orders, :closed_at, :datetime
  end
end
