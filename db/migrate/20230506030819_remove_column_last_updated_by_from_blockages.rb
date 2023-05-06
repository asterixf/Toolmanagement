class RemoveColumnLastUpdatedByFromBlockages < ActiveRecord::Migration[7.0]
  def change
    remove_column :blockages, :last_updated_by, :string
  end
end
