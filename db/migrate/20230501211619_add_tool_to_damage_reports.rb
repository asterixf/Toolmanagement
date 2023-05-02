class AddToolToDamageReports < ActiveRecord::Migration[7.0]
  def change
    add_reference :damage_reports, :tool, null: false, foreign_key: true
    remove_reference :damage_reports, :blockage
    remove_reference :damage_reports, :cavity
  end
end
