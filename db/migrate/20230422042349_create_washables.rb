class CreateWashables < ActiveRecord::Migration[7.0]
  def change
    create_table :washables do |t|
      t.references :wash_order, null: false, foreign_key: true
      t.references :blockage, null: false, foreign_key: true

      t.timestamps
    end
  end
end
