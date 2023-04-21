class CreateBlockages < ActiveRecord::Migration[7.0]
  def change
    create_table :blockages do |t|
      t.references :tool, null: false, foreign_key: true
      t.string :reason
      t.string :created_by
      t.string :last_updated_by
      t.string :status

      t.timestamps
    end
  end
end
