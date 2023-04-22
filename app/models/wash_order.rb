class WashOrder < ApplicationRecord
  belongs_to :tool
  has_and_belongs_to_many :blockages
  validates :created_by, :status, presence: true
end
