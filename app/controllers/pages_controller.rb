class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def wo_blockages
    @tools_wash = Tool.joins(:blockages)
    .where(blockages: { reason: "wash", status: "open" })
    .group(:id)
    .having("COUNT(blockages.id) >= ?", 1)
  end

  def d_blockages
    @tools_damaged = Tool.joins(:blockages)
    .where(blockages: { reason: "damaged", status: "open"})
    .group(:id)
    .having("COUNT(blockages.id) >= ?", 1)
  end
end
