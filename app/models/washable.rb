class Washable < ApplicationRecord
  belongs_to :wash_order
  belongs_to :blockage
end
