class AddCreatedByToTools < ActiveRecord::Migration[7.0]
  def change
    add_column :tools, :created_by, :string
  end
end
