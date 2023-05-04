class DropWashablesTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :washables
  end
end
