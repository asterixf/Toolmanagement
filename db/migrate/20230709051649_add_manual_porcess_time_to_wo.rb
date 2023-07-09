class AddManualPorcessTimeToWo < ActiveRecord::Migration[7.0]
  def change
    add_column :wash_orders, :manual_process_start, :datetime
    add_column :wash_orders, :manual_process_end, :datetime
  end
end
