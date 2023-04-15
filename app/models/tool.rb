class Tool < ApplicationRecord
  validates(
  :alias,
  :sap,
  :capacity,
  :technology,
  :segment,
  :bu,
  :volume,
  :customer,
  :spares,
  presence: true)

  validates :sap, uniqueness: true
end
