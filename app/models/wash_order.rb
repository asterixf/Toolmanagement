class WashOrder < ApplicationRecord
  belongs_to :tool
  has_many :washables
  has_many :blockages, through: :washables
  validates :status, presence: true
end
