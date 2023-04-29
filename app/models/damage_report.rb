class DamageReport < ApplicationRecord
  belongs_to :cavity
  belongs_to :blockage
end
