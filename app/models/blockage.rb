class Blockage < ApplicationRecord
  validates :reason, presence: true
  belongs_to :cavity
  belongs_to :tool
end
