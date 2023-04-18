class CreateWashOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :wash_orders do |t|
      t.references :tool, null: false
      t.string :created_by
      t.string :tool_alias
      t.integer :qty
      t.text :comments
      t.string :status
      t.string :closed_by
      t.time :washing_time
      t.timestamps
    end
  end
end
