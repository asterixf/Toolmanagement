class WashOrder < ApplicationRecord
  belongs_to :tool
  has_many :washables
  has_many :blockages, through: :washables
end
