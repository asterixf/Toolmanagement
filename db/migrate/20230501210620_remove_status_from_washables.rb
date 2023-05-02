class RemoveStatusFromWashables < ActiveRecord::Migration[7.0]
  def change
    remove_column :washables, :status, :string
  end
end
