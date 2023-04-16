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
end
