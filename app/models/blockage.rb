class Blockage < ApplicationRecord

  include PgSearch::Model
  pg_search_scope :global_search,
  against: [ :reason ],
  associated_against: {
    tool: [ :sap, :alias ]
  },
  using: {
    tsearch: { prefix: true }
  }

  validates :reason, presence: true
  belongs_to :cavity
  belongs_to :tool
end
