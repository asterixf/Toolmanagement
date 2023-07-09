class AddWashTimeToWashOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :wash_orders, :wash_time, :integer
  end
end
