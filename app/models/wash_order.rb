class WashOrder < ApplicationRecord
  belongs_to :tool
  validates(:created_by, :tool_alias, :qty, :status, presence: true)
end
