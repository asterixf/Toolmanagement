class Cavity < ApplicationRecord
  belongs_to :tool
  has_one :blockage
  validates :num, presence: true, uniqueness: { scope: :tool_id }
  validates :status, :created_by, :status, presence: true
  scope :released, -> { where(status: "released") }
  scope :unblocked, -> { left_outer_joins(:blockage).where(blockages: { id: nil }) }
  def cavity_num
    num
  end
end
