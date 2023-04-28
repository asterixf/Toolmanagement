class TimeToWasOrder < ActiveRecord::Migration[7.0]
  def change
    remove_column :wash_orders, :wash_time
    add_column :wash_orders, :time, :integer
  end
end
