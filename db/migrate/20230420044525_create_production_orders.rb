class CreateProductionOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :production_orders do |t|
      t.references :tool, null: false, foreign_key: true
      t.string :created_by
      t.text :cavities_in_tool
      t.text :comments
      t.string :status

      t.timestamps
    end
  end
end
