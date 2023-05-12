class Cavity < ApplicationRecord
  belongs_to :tool
  has_many :blockages, dependent: :destroy
  # validates :num, presence: true, uniqueness: { scope: :tool_id }
  validates :num, presence: true
  validates :status, :created_by, :status, presence: true
end
