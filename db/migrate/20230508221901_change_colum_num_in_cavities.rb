class ChangeColumNumInCavities < ActiveRecord::Migration[7.0]
  def change
    change_column :cavities, :num, :string
  end
end
