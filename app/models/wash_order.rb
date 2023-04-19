class WashOrder < ApplicationRecord
  belongs_to :tool
  validates(:created_by, :qty, :status, presence: true)
end
