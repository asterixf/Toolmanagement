class AddQualityColumnToDamageReport < ActiveRecord::Migration[7.0]
  def change
    add_column :damage_reports, :quality, :string
  end
end
