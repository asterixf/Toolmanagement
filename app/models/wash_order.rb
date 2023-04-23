class WashOrder < ApplicationRecord
  belongs_to :tool
  has_many :washables, dependent: :destroy
  has_many :blockages, through: :washables
end
