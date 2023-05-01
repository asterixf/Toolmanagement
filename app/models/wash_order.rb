class WashOrder < ApplicationRecord
  belongs_to :tool
  has_many :washables
  has_many :blockages, through: :washables
  validates :status, presence: true

  def formatted_time
    hours = time / 3600
    minutes = (time % 3600) / 60
    seconds = time % 60
    format('%02d:%02d:%02d', hours, minutes, seconds)
  end
end
