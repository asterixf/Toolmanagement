class RenameMaxFromTools < ActiveRecord::Migration[7.0]
  def change
    rename_column :tools, :max, :capacity
  end
end
