class Blockage < ApplicationRecord
  belongs_to :tool
  validates :reason, presence: true
  include PgSearch::Model
  pg_search_scope :search_by_params,
      against: [:alias, :sap, :customer, :location, :bu, :segment],
      using: {
      tsearch: { prefix: true }
      }
end
