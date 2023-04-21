class ProductionOrder < ApplicationRecord
  belongs_to :tool
  validates :cavities_in_tool, :status, :created_by, presence: true
end
