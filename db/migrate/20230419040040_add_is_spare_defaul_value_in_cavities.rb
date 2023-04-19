class AddIsSpareDefaulValueInCavities < ActiveRecord::Migration[7.0]
  def change
    change_column :cavities, :is_spare, :boolean, default: false
  end
end
