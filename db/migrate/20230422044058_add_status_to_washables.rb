class AddStatusToWashables < ActiveRecord::Migration[7.0]
  def change
    add_column :washables, :status, :string
  end
end
