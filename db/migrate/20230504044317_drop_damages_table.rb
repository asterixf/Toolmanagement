class DropDamagesTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :damages
  end
end
