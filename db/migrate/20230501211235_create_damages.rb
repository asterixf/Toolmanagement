class CreateDamages < ActiveRecord::Migration[7.0]
  def change
    create_table :damages do |t|
      t.references :blockage, null: false, foreign_key: true
      t.references :damage_report, null: false, foreign_key: true

      t.timestamps
    end
  end
end
