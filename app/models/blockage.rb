class Blockage < ApplicationRecord
  validates :reason, presence: true
  belongs_to :cavity
  # validates :cavity, :reason , presence: true
end
