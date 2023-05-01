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

  def washorders
    @wash_orders = WashOrder.all
  end

  def damagedtools
    @damaged_tools = Tool.where(status: "Damaged")
  end
end
