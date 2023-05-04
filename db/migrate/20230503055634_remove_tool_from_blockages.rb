class RemoveToolFromBlockages < ActiveRecord::Migration[7.0]
  def change
    remove_reference :blockages, :tool, null: false, foreign_key: true
  end
end
