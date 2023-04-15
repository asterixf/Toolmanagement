class RemoveUserFromTool < ActiveRecord::Migration[7.0]
  def change
    remove_column(:tools, :user_id)
  end
end
