class DamageReport < ApplicationRecord
  has_many :damages
  belongs_to :tool
  has_many :blockages, through: :damages
  validates :quality, :machine_num, :shift, :operator, :bcl, :process_eng, :damaged_part, :description, :cause, presence: true
end
