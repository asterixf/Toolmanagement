class ChangeColumnsInWashOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :wash_orders, :tool_alias
    remove_column :wash_orders, :qty
  end
end
