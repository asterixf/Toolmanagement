require 'csv'

class Tool < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_params,
      against: [:alias, :sap, :customer, :location, :bu, :segment, :technology],
      using: {
      tsearch: { prefix: true }
      }
  has_many :wash_orders, dependent: :destroy
  has_many :cavities, dependent: :destroy
  has_many :blockages, dependent: :destroy
  has_one :production_order, dependent: :destroy
  has_many :damage_reports, through: :cavities
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
  validates :sap, uniqueness: true
  has_one_attached :layout
  validate :layout_mime_type

  def update_available
    update(available: (active * 100) / capacity)
  end

  private

  def layout_mime_type
    return unless layout.attached?

    if layout.attached? && !layout.content_type.in?(%w(application/pdf))
      errors.add(:layout, 'must be a PDF')
    end
  end
end
