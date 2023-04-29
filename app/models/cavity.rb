class Cavity < ApplicationRecord
  belongs_to :tool
  has_one :blockage
  has_many :damage_reports
  validates :num, presence: true, uniqueness: { scope: :tool_id }
  validates :status, :created_by, :status, presence: true
end
