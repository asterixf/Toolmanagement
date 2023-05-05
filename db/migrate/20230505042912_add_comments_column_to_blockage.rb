class AddCommentsColumnToBlockage < ActiveRecord::Migration[7.0]
  def change
    add_column :blockages, :comments, :text
  end
end
