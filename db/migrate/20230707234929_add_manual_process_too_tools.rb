class AddManualProcessTooTools < ActiveRecord::Migration[7.0]
  def change
    add_column :tools, :manual_process, :boolean, default: false
  end
end
