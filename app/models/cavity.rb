class Cavity < ApplicationRecord
  belongs_to :tool
  validates :num, presence: true, uniqueness: { scope: :tool_id }
  validates :status, :created_by, :status, presence: true
end
