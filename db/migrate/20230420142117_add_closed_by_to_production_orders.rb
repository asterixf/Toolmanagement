class AddClosedByToProductionOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :production_orders, :closed_by, :string
  end
end
