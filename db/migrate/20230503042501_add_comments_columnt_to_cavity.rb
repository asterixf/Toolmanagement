class AddCommentsColumntToCavity < ActiveRecord::Migration[7.0]
  def change
    add_column :cavities, :comments, :text
  end
end
