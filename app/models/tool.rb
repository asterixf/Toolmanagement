require 'csv'

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
    presence: true
  )
  validates :sap, uniqueness: true
  has_one_attached :layout
  validate :layout_mime_type

  def self.to_csv
    # Select the attributes that are needed in csv
    attribs = [:id, :alias, :sap, :plant, :bu, :technology, :volume, :customer, :capacity, :location, :damaged, :blocked, :active, :spares, :segment, :available]
  # iterate over all the passed products and one by one create row of the csv
    CSV.generate(headers: true) do |csv|
      csv << attribs
      all.each do |product|
      csv << attribs.map{ |attr| product.send(attr) }
      end
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
