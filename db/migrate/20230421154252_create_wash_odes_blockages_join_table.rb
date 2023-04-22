class CreateWashOdesBlockagesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :wash_orders, :blockages do |t|
      t.index :wash_order_id
      t.index :blockage_id
    end
  end
end
