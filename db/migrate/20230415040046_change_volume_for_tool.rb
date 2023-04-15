class ChangeVolumeForTool < ActiveRecord::Migration[7.0]
  def change
    change_column :tools, :volume, :bigint
  end
end
