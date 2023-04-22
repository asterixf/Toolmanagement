class Blockage < ApplicationRecord
  validates :reason, presence: true
  include PgSearch::Model
  pg_search_scope :search_by_params,
      against: [:alias, :sap, :customer, :location, :bu, :segment],
      using: {
      tsearch: { prefix: true }
      }
  belongs_to :cavity
  belongs_to :tool
  has_and_belongs_to_many :wash_orders
end
