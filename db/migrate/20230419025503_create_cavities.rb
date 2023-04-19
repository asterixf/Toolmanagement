class CreateCavities < ActiveRecord::Migration[7.0]
  def change
    create_table :cavities do |t|
      t.references :tool, null: false, foreign_key: true
      t.string :created_by
      t.string :last_updated_by
      t.integer :num
      t.string :status
      t.boolean :is_spare
      t.timestamps
    end
  end
end
