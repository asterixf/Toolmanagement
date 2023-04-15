class RemoveLayoutFromTools < ActiveRecord::Migration[7.0]
  def change
    remove_column(:tools, :layout)
  end
end
