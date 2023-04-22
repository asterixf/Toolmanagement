class Cavity < ApplicationRecord
  belongs_to :tool
  has_one :blockage
  validates :num, presence: true, uniqueness: { scope: :tool_id }
  validates :status, :created_by, :status, presence: true
end
