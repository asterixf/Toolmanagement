class DropBlockagesWashOrders < ActiveRecord::Migration[7.0]
  def change
    drop_table :blockages_wash_orders
  end
end
