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
  has_many :washables
  has_many :wash_orders, through: :washables
  has_many :damage_reports
  validates :cavity, :reason , presence: true
end
