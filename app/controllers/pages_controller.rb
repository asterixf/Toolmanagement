class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @average_availability = Tool.all.average(:available)&.round(2) || 0
    @damper_availability = Tool.where(bu: "Damper").average(:available)&.round(2) || 0
    @steering_availability = Tool.where(bu: "Steering").average(:available)&.round(2) || 0
    @low_volume_availability = Tool.where(bu: "Low_Volume").average(:available)&.round(2) || 0
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
