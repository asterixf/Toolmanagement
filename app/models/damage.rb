class Damage < ApplicationRecord
  belongs_to :blockage
  belongs_to :damage_report
end
