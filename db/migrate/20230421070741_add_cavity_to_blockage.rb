class AddCavityToBlockage < ActiveRecord::Migration[7.0]
  def change
    add_reference :blockages, :cavity, null: false, foreign_key: true
  end
end
