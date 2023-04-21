class ChangeClosedByInProductionOrders < ActiveRecord::Migration[7.0]
  def change
    rename_column :production_orders, :closed_by, :last_updated_by
  end
end
