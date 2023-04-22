class AddCavityReferenceInBlockages < ActiveRecord::Migration[7.0]
  def change
    add_reference :blockages, :cavity, null: true, foreign_key: true
  end
end
