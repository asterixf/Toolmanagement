class CreateDamageReport < ActiveRecord::Migration[7.0]
  def change
    create_table :damage_reports do |t|
      t.references :blockage, null: false, foreign_key: true
      t.references :cavity, null: false, foreign_key: true
      t.string :created_by
      t.string :machine_num
      t.string :shift
      t.string :operator
      t.string :bcl
      t.string :process_eng
      t.string :damaged_part
      t.text :description
      t.text :cause
      t.text :comments
      t.string :status
      t.string :closed_by
      t.timestamps
    end
  end
end
