require 'csv'

class Tool < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_params,
      against: [:alias, :sap, :customer, :location, :bu, :segment, :technology],
      using: {
      tsearch: { prefix: true }
      }
  has_many :cavities
  has_many :wash_orders
  has_many :blockages
  has_many :production_orders
  has_many :damage_reports
  validates(
    :alias,
    :sap,
    :capacity,
    :technology,
    :segment,
    :bu,
    :volume,
    :customer,
    :damaged,
    :blocked,
    :active,
    :spares,
    presence: true
  )
  has_one_attached :layout
  validate :layout_mime_type

  def update_available
    if capacity === 0
      update(available: nil)
    else
      result = (active * 100) / capacity.to_f
      update(available: result.round(2))
    end
  end

  private

  def layout_mime_type
    return unless layout.attached?
    if layout.attached? && !layout.content_type.in?(%w(application/pdf))
      errors.add(:layout, 'must be a PDF')
    end
  end
end
