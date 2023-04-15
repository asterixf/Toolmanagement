class RemoveUserfromTools < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :tools, column: :user_id
    add_column(:tools, :last_updated_by, :string)
    add_column(:tools, :location, :string)
  end
end
